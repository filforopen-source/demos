import { HarmBlockThreshold, HarmCategory } from "@google/genai";

export const questionGenConfig = {
            maxOutputTokens: 65535,
            temperature: 0.7,
            topP: 0.95,
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
                description: "A list of 2 to 4 questions to tweak the supplied image.",
                items: {
                    type: "OBJECT",
                    properties: {
                        question: {
                            type: "STRING",
                            description: "The question to ask the user to refine their prompt."
                        },
                        type: {
                            type: "STRING",
                            description: "The type of answer expected. Must be one of: 'multipleChoiceQuestion', 'zeroToOneQuestion', 'negativeOneToOneQuestion', 'textQuestion'"
                        },
                    },
                    required: ["question", "type"]
                },
            },
        };

export const sliderValueGenConfig = {
            maxOutputTokens: 65535,
            temperature: 0.7,
            topP: 0.95,
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
                    minValueLabel: {
                        type: "STRING",
                        description: "The label to display for the minimum value of the slider. Only used for 'zeroToOneQuestion' and 'negativeOneToOneQuestion'"
                    },
                    maxValueLabel: {
                        type: "STRING",
                        description: "The label to display for the maximum value of the slider. Only used for 'zeroToOneQuestion' and 'negativeOneToOneQuestion'"
                    },
                },
                required: ["minValueLabel", "maxValueLabel"]
            },
        };

export const textValueGenConfig = {
            maxOutputTokens: 65535,
            temperature: 0.7,
            topP: 0.95,
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
                description: "A list of 2 to 4 acceptable answers based on the supplied question",
                items: {
                    type: "STRING",
                    description: "A single acceptable answer based on the supplied question"
                },
            },
        };
                        