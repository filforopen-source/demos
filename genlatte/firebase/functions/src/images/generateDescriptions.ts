import { logger } from "firebase-functions/logger";
import { withRetry } from "../common";
import { GoogleGenAI } from "@google/genai";

import { fetchRemoteConfigValues } from "../common/fetchRemoteConfig";

export const generateDescription = async (base64ImageFile: string, orderId?: string) => {
    const projectId = process.env.GCP_PROJECT || process.env.GCLOUD_PROJECT;
    const genAI = new GoogleGenAI({ vertexai: true, project: projectId, location: 'global' });
    const { descriptionPromptInstructions } = await fetchRemoteConfigValues();
    const prompt = [
        {
            inlineData: {
                mimeType: "image/jpeg",
                data: base64ImageFile,
            }
        },
        {text: descriptionPromptInstructions}
    ];
    const genConfig = {
        maxOutputTokens: 20000,
        temperature: 1,
        topP: 0.95,
    };
    return await withRetry(async () => {
        const chat = genAI.chats.create({
            model: "gemini-3.1-flash-lite-preview",
            config: genConfig
        });
        const result = await chat.sendMessage({message:prompt});
        if(!result.text) {
            logger.error("No text data returned from Gemini pro for image description");
            throw new Error("No text data returned from Gemini Pro");
        }
        logger.log(`Description: ${result.text}`);
        return result.text;
    }, 5, 1000, orderId).catch((e) => {
        logger.error(`Error generating description after retries for orderId: ${orderId}`, e);
        return 'could not generate a description';
    });
}