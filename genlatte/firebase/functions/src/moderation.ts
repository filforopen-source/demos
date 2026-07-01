import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import { GoogleGenAI, HarmBlockThreshold, HarmCategory, ThinkingLevel } from '@google/genai';
import { withRetry } from "./common";
import { fetchRemoteConfigValues } from "./common/fetchRemoteConfig";

export const moderation = onCall(async (request) => {
    let {name} = request.data;
    if (!name) {
        throw new HttpsError('invalid-argument', 'Missing name');
    }

    return word_moderation(name);

});

export const word_moderation = (async (word_moderation: string, orderId?: string) => {
    if (!word_moderation) {
        throw new Error('Missing word_moderation');
    }

    try {
        logger.info(`Moderating ${word_moderation}`);

        const projectId = process.env.GCP_PROJECT || process.env.GCLOUD_PROJECT;
        const genAI = new GoogleGenAI({ vertexai: true, project: projectId, location: 'global' });

        const { textModel, moderationPromptInstructions } = await fetchRemoteConfigValues();

        const moderation = await stringModeration(word_moderation, genAI, textModel, moderationPromptInstructions, orderId);

        return {
            moderation
        };
    } catch (e: any) {
        logger.error("Global error in generateImages", e);
        // Safely return the error to the client
        throw new HttpsError("internal", "An error occurred while generating images. Please try again later.", e.message);
    }

});

async function stringModeration(name: any, genAI: GoogleGenAI, textModel: string, moderationPromptInstructions: string, orderId?: string) {

    const prompt = `${moderationPromptInstructions}\n${name}\n`;

    const genConfig = {
        maxOutputTokens: 65535,
        temperature: 1,
        topP: 0.95,
        seed: 0,
        thinkingConfig: {
            thinkingLevel: ThinkingLevel.HIGH,
        },
        safetySettings: [
            {
                category: HarmCategory.HARM_CATEGORY_HATE_SPEECH,
                threshold: HarmBlockThreshold.BLOCK_NONE,
            },
            {
                category: HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT,
                threshold: HarmBlockThreshold.BLOCK_NONE,
            },
            {
                category: HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT,
                threshold: HarmBlockThreshold.BLOCK_NONE,
            },
            {
                category: HarmCategory.HARM_CATEGORY_HARASSMENT,
                threshold: HarmBlockThreshold.BLOCK_NONE,
            }
        ],
        responseMimeType: 'application/json',
        responseSchema: {
            type: "OBJECT",
            properties: {
                isAllowed: {
                    type: "BOOLEAN",
                },
                moderationReason: {
                    type: "STRING",
                },
            },
            required: ["isAllowed", "moderationReason"],
        },
    };

    return await withRetry(async () => {
        const chat = genAI.chats.create({ model: textModel, config: genConfig });
        const result = await chat.sendMessage({ message: prompt });
        if (!result.text) {
            throw new Error("No result returned");
        }
        
        try {
            return JSON.parse(result.text) as { isAllowed: boolean, moderationReason: string };
        } catch (e) {
            logger.warn("Failed to parse moderation result. Falling back to default.", e);
            return {
                isAllowed: false,
                moderationReason: "Failed to parse result",
            };
        }
    }, 3, 1000, orderId);
}
