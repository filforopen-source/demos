import { HttpsError } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import { GenerateContentConfig, GoogleGenAI } from '@google/genai';
import { withRetry } from "../common";
import { fetchRemoteConfigValues } from "../common/fetchRemoteConfig";
import { questionGenConfig, sliderValueGenConfig, textValueGenConfig } from "./reviserConfigs";

const MODEL = "gemini-3-flash-preview";

const getChat = (config?: GenerateContentConfig) => {
    const projectId = process.env.GCP_PROJECT || process.env.GCLOUD_PROJECT;
    const genAI = new GoogleGenAI({ vertexai: true, project: projectId, location: 'global' });
    const chat = genAI.chats.create({ model: MODEL, config: config });
    return chat;
}

const generateQuestions = async(base64ImageFile: string, questionGenPromptInstructions: string, orderId?: string) => {
    if (!base64ImageFile || typeof base64ImageFile !== 'string') {
        return;
    }

    try {
        const chat = getChat(questionGenConfig);

        const content = [
            {
                inlineData: {
                    mimeType: "image/png",
                    data: base64ImageFile,
                },
            },
            {text: questionGenPromptInstructions}
        ]

        return await withRetry(async () => {
            logger.info("Generating questions with image ");
            const result = await chat.sendMessage({ message: content });
            if (!result.text) {
                logger.error("no text returned from Gemini");
                throw new Error("No text returned from Gemini");
            }

            try {
                logger.info("response from Gemini: ", result.text);
                const questions = JSON.parse(result.text);
                return questions;
            } catch (e) {
                logger.warn("Failed to parse JSON response from Gemini, attempting fallback", e);
                throw new Error("Invalid output format from GenAI");
            }
        }, 3, 1000, orderId);

    } catch (e: any) {
        logger.error("Error in generateQuestions function", e);
        throw new HttpsError("internal", "An error occurred while generating revisions.", e.message);
    }
}

export const generateAnswersOrLabels = async(promptWithQuestionEmbedded: string, config: any, orderId?: string) => {
    if (!promptWithQuestionEmbedded || typeof promptWithQuestionEmbedded !== 'string') {
        return;
    }

    try {
        const chat = getChat(config);

        const content = [
            {text: promptWithQuestionEmbedded}
        ]

        return await withRetry(async () => {
            const result = await chat.sendMessage({ message: content });
            if (!result.text) {
                logger.error("no text returned from Gemini");
                throw new Error("No text returned from Gemini");
            }

            try {
                logger.info("response from Gemini: ", result.text);
                const questions = JSON.parse(result.text);
                return questions;
            } catch (e) {
                logger.warn("Failed to parse JSON response from Gemini, attempting fallback", e);
                throw new Error("Invalid output format from GenAI");
            }
        }, 3, 1000, orderId);
    } catch (e: any) {
        logger.error("Error in generateAnswersOrLabels function", e);
        throw new HttpsError("internal", "An error occurred while generating revisions.", e.message);
    }
}

export const reviseImageQuestionGenerator = async (base64ImageFile: string, orderId?: string) => {
    if (!base64ImageFile || typeof base64ImageFile !== 'string') {
        return;
    }

    const { questionGenPromptInstructions, sliderValueGenPromptInstructions, textValueGenPromptInstructions } = await fetchRemoteConfigValues();

    const questions = await generateQuestions(base64ImageFile, questionGenPromptInstructions, orderId);
    const questionsWithValues = await Promise.all(questions.map(async (question: any) => {
        let fullQuestion = question;
        if (question.type === "multipleChoiceQuestion") {
            logger.info("Generating acceptable answers for question: ", question.question);
            const prompt = textValueGenPromptInstructions.replace("{{userSuppliedQuestion}}", question.question);
            fullQuestion.acceptableAnswers = await generateAnswersOrLabels(prompt, textValueGenConfig, orderId);
        }
        if (question.type === "zeroToOneQuestion" || question.type === "negativeOneToOneQuestion") {
            logger.info("Generating slider values for question: ", question.question);
            const prompt = sliderValueGenPromptInstructions.replace("{{userSuppliedQuestion}}", question.question);
            const sliderValues = await generateAnswersOrLabels(prompt, sliderValueGenConfig, orderId);
            fullQuestion.minValueLabel = sliderValues.minValueLabel;
            fullQuestion.maxValueLabel = sliderValues.maxValueLabel;
        }
        return fullQuestion;
    }));

    logger.info("questionsWithValues: ", questionsWithValues);
    console.log("questionsWithValues: ", questionsWithValues);
    return questionsWithValues;
}
