import { HarmBlockThreshold, HarmCategory, ThinkingLevel } from "@google/genai";

export const happyPlacePromptPowerGenConfig = {
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
        type: "ARRAY",
        items: {
            type: "STRING",
        },
    },
};