import { logger } from "firebase-functions/logger";
import { GoogleGenAI } from "@google/genai";
import { fetchRemoteConfigValues } from "../common/fetchRemoteConfig";
import { withRetry } from "../common";
import { happyPlacePromptPowerGenConfig } from "./configs/happyPlacePromptPower";

/**
 * Enhances a user prompt for image generation using Gemini 3 Flash.
 */
async function powerUpPromptLogic(prompt: string, genAI: GoogleGenAI, powerupPromptInstructions: string, textModel: string, orderId?: string): Promise<string[]> {

    const prePoweredUpPrompt = `
    ${powerupPromptInstructions}

    Please generate 4 distinct variations of the prompt based on the original prompt.
    Return the response as a valid JSON array of strings. e.g. ["prompt1", "prompt2", "prompt3", "prompt4"].
    Do not include any markdown formatting or code blocks in the response, just the raw JSON.

    ORIGINAL PROMPT:
    ${prompt}
    
    OUTPUT PROMPTS (JSON): 
    `;

    return await withRetry(async () => {
        const chat = genAI.chats.create({ model: textModel, config: happyPlacePromptPowerGenConfig });
        const result = await chat.sendMessage({ message: prePoweredUpPrompt });
        if (!result.text) {
            logger.log("No text returned from Gemini Flash");
            throw new Error("No text returned from Gemini Flash");
        }
        
        try {
            const prompts = JSON.parse(result.text);
            if (Array.isArray(prompts) && prompts.length > 0) {
                 // Ensure we have exactly 4 prompts, or at least return what we have
                 return prompts.slice(0, 4).map(p => String(p));
            }
            // Fallback if not an array
            return [result.text];
        } catch (e) {
            logger.warn("Failed to parse JSON from powerUpPromptLogic, returning raw text as single prompt", e);
            return [result.text];
        }
    }, 3, 1000, orderId);
}

export const generatePromptsForHappyPlace = async (prompt: string, orderId?: string) => {
    if (!prompt || prompt === "") {
        throw new Error("Prompt must not be null or empty");
    }

    try {
        logger.info(`Generating prompts for prompt: ${prompt}`);

        const projectId = process.env.GCP_PROJECT || process.env.GCLOUD_PROJECT;
        const genAI = new GoogleGenAI({ vertexai: true, project: projectId, location: 'global' });

        const { powerupPromptInstructions, textModel } = await fetchRemoteConfigValues();

        const poweredUpPrompts = await powerUpPromptLogic(prompt, genAI, powerupPromptInstructions, textModel, orderId);

        return poweredUpPrompts;
    } catch (e: any) {
        logger.error("Global error in generatePromptsForHappyPlace", e);
        // Safely return the error to the client
        return [];
    }
}

/**
 * Enhances a user prompt for image generation using Gemini 3 Flash.
 */
async function powerUpRevisedPromptLogic(prompt: string, genAI: GoogleGenAI, powerupPromptInstructions: string, textModel: string, answers: string, orderId?: string): Promise<string[]> {

    const prePoweredUpPrompt = `
    ${powerupPromptInstructions}

    Please generate 4 distinct variations of the prompt based on the original prompt and the instructions
    to revise the image.
    Return the response as a valid JSON array of strings. e.g. ["prompt1", "prompt2", "prompt3", "prompt4"].
    Do not include any markdown formatting or code blocks in the response, just the raw JSON.

    ORIGINAL PROMPT:
    ${prompt}

    Instructions for revising the original image:
    ${answers}
    
    OUTPUT PROMPTS (JSON): 
    `;

    return await withRetry(async () => {
        const chat = genAI.chats.create({ model: textModel, config: happyPlacePromptPowerGenConfig });
        const result = await chat.sendMessage({ message: prePoweredUpPrompt });
        if (!result.text) {
            logger.log("No text returned from Gemini Flash");
            throw new Error("No text returned from Gemini Flash");
        }
        
        try {
            const prompts = JSON.parse(result.text);
            if (Array.isArray(prompts) && prompts.length > 0) {
                 // Ensure we have exactly 4 prompts, or at least return what we have
                 return prompts.slice(0, 4).map(p => String(p));
            }
            // Fallback if not an array
            return [result.text];
        } catch (e) {
            logger.warn("Failed to parse JSON from powerUpPromptLogic, returning raw text as single prompt", e);
            return [result.text];
        }
    }, 3, 1000, orderId);
}

export const generateRevisedImagesPrompts = async (prompt: string, answers: string, orderId?: string) => {
    if (!prompt || prompt === "") {
        throw new Error("Prompt must not be null or empty");
    }
    if (!answers || answers.length === 0) {
        throw new Error("Answers must not be null or empty");
    }

    try {
        logger.info(`Generating prompts for prompt: ${prompt}`);

        const projectId = process.env.GCP_PROJECT || process.env.GCLOUD_PROJECT;
        const genAI = new GoogleGenAI({ vertexai: true, project: projectId, location: 'global' });

        const { powerupPromptInstructions, textModel } = await fetchRemoteConfigValues();

        const revisedPrompts = await powerUpRevisedPromptLogic(prompt, genAI, powerupPromptInstructions, textModel, answers, orderId);
        
        return revisedPrompts;
    } catch (e: any) {
        logger.error("Global error in generateRevisedImagesPrompts", e);
        // Safely return the error to the client
        return [];
    }
}