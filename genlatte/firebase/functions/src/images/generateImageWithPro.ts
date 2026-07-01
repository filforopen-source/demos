import * as logger from "firebase-functions/logger";
import { GoogleGenAI, HarmBlockThreshold, HarmCategory, ThinkingLevel } from '@google/genai';
import { withRetry } from "../common";
import { fetchRemoteConfigValues } from "../common/fetchRemoteConfig";

/**
 * Generates four images using Gemini 3 Pro (Image Preview) based on a powered-up prompt.
 */
export async function generateImageWithPro(prompt: string, orderId?: string): Promise<{image: string, prompt: string}> {
    const { imageModel } = await fetchRemoteConfigValues();
    logger.log("Image model", imageModel);
    logger.log(`Generating image for prompt: ${prompt}`);
    const projectId = process.env.GCP_PROJECT || process.env.GCLOUD_PROJECT;
    logger.log("Project ID", projectId);
    const genAI = new GoogleGenAI({ vertexai: true, project: projectId, location: 'global' });
    const proConfig: any = {
        maxOutputTokens: 32768,
        temperature: 1,
        topP: 0.95,
        responseModalities: ["IMAGE"] as any,
        imageConfig: {
            aspectRatio: "1:1",
            imageSize: "512",
            outputMimeType: "image/png",
        },
        safetySettings: [
            {
                category: HarmCategory.HARM_CATEGORY_HATE_SPEECH,
                threshold: HarmBlockThreshold.BLOCK_ONLY_HIGH,
            },
            {
                category: HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT,
                threshold: HarmBlockThreshold.BLOCK_ONLY_HIGH,
            },
            {
                category: HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT,
                threshold: HarmBlockThreshold.BLOCK_ONLY_HIGH,
            },
            {
                category: HarmCategory.HARM_CATEGORY_HARASSMENT,
                threshold: HarmBlockThreshold.BLOCK_ONLY_HIGH,
            }
        ],
    };
    if(imageModel.includes("gemini-3")) {
        proConfig.thinkingConfig = {
            thinkingLevel: ThinkingLevel.MINIMAL,
        };
    }

    return await withRetry(async () => {
        let base64Data = "";
        let mimeType = "image/png";

        if (imageModel.includes('gemini-3')) {
            const resultStream = await genAI.models.generateContentStream({
                model: imageModel,
                contents: [{ role: 'user', parts: [{ text: prompt }] }],
                config: proConfig
            });
            for await (const chunk of resultStream) {
                const candidate = chunk.candidates?.[0];
                const imagePart = candidate?.content?.parts?.find((p: any) => p.inlineData);
                if (imagePart && imagePart.inlineData && imagePart.inlineData.data) {
                    base64Data += imagePart.inlineData.data;
                    mimeType = imagePart.inlineData.mimeType || mimeType;
                }
            }
        } else {
            const result = await genAI.models.generateContent({
                model: imageModel,
                contents: [{ role: 'user', parts: [{ text: prompt }] }],
                config: proConfig
            });
            const candidate = result.candidates?.[0];
            const imagePart = candidate?.content?.parts?.find((p: any) => p.inlineData);
            if (imagePart && imagePart.inlineData && imagePart.inlineData.data) {
                base64Data = imagePart.inlineData.data;
                mimeType = imagePart.inlineData.mimeType || mimeType;
            }
        }

        if (base64Data.length > 0) {
            return {
                image: `data:${mimeType};base64,${base64Data}`,
                prompt: prompt
            };
        }
        throw new Error("No image data returned from Gemini Pro");
    }, 5, 1000, orderId).catch((e) => {
        logger.error(`Error generating image after retries for orderId: ${orderId}`, e);
        return {
            image: 'could not generate an image',
            prompt: prompt
        };
    });
}