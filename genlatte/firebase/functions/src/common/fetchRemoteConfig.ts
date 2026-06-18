import { getRemoteConfig } from "firebase-admin/remote-config";
import { 
    DEFAULT_POWERUP_PROMPT, 
    DEFAULT_MODERATION_PROMPT,
    DEFAULT_DESCRIPTION_PROMPT,
    DEFAULT_QUESTION_GEN_PROMPT,
    DEFAULT_SLIDER_VALUE_GEN_PROMPT,
    DEFAULT_TEXT_VALUE_GEN_PROMPT
} from "./prompts";
import { logger } from "firebase-functions/logger";

/**
 * Fetches Remote Config values for power-up prompt and image model.
 */
export async function fetchRemoteConfigValues() {
    const rc = getRemoteConfig();
    let powerupPromptInstructions = DEFAULT_POWERUP_PROMPT;
    let moderationPromptInstructions = DEFAULT_MODERATION_PROMPT;
    let descriptionPromptInstructions = DEFAULT_DESCRIPTION_PROMPT;
    let questionGenPromptInstructions = DEFAULT_QUESTION_GEN_PROMPT;
    let sliderValueGenPromptInstructions = DEFAULT_SLIDER_VALUE_GEN_PROMPT;
    let textValueGenPromptInstructions = DEFAULT_TEXT_VALUE_GEN_PROMPT;
    let imageModel = "gemini-3.1-flash-image-preview";
    let textModel = "gemini-3-flash-preview";
    let imageParallelism = 4;

    try {
        const template = await rc.getServerTemplate({
            defaultConfig: {
                "POWERUP_PROMPT_BRANCH_SUFFIX": DEFAULT_POWERUP_PROMPT,
                "MODERATION_PROMPT_BRANCH_SUFFIX": DEFAULT_MODERATION_PROMPT,
                "DESCRIPTION_PROMPT_BRANCH_SUFFIX": DEFAULT_DESCRIPTION_PROMPT,
                "QUESTION_GEN_PROMPT_BRANCH_SUFFIX": DEFAULT_QUESTION_GEN_PROMPT,
                "SLIDER_VALUE_GEN_PROMPT_BRANCH_SUFFIX": DEFAULT_SLIDER_VALUE_GEN_PROMPT,
                "TEXT_VALUE_GEN_PROMPT_BRANCH_SUFFIX": DEFAULT_TEXT_VALUE_GEN_PROMPT,
                "IMAGE_MODEL_BRANCH_SUFFIX": "gemini-3.1-flash-image-preview",
                "TEXT_MODEL_BRANCH_SUFFIX": "gemini-3-flash-preview",
                "IMAGE_PARALLELISM": 4,
            },
        });
        const config = template.evaluate();
        powerupPromptInstructions = config.getString("POWERUP_PROMPT_BRANCH_SUFFIX") || powerupPromptInstructions;
        moderationPromptInstructions = config.getString("MODERATION_PROMPT_BRANCH_SUFFIX") || moderationPromptInstructions;
        descriptionPromptInstructions = config.getString("DESCRIPTION_PROMPT_BRANCH_SUFFIX") || descriptionPromptInstructions;
        questionGenPromptInstructions = config.getString("QUESTION_GEN_PROMPT_BRANCH_SUFFIX") || questionGenPromptInstructions;
        sliderValueGenPromptInstructions = config.getString("SLIDER_VALUE_GEN_PROMPT_BRANCH_SUFFIX") || sliderValueGenPromptInstructions;
        textValueGenPromptInstructions = config.getString("TEXT_VALUE_GEN_PROMPT_BRANCH_SUFFIX") || textValueGenPromptInstructions;
        imageModel = config.getString("IMAGE_MODEL_BRANCH_SUFFIX") || imageModel;
        textModel = config.getString("TEXT_MODEL_BRANCH_SUFFIX") || textModel;
        imageParallelism = config.getNumber("IMAGE_PARALLELISM") || imageParallelism;
    } catch (err) {
        logger.warn("Failed to fetch Remote Config, using default POWERUP_PROMPT and IMAGE_MODEL", err);
    }

    return { 
        powerupPromptInstructions, 
        moderationPromptInstructions, 
        descriptionPromptInstructions,
        questionGenPromptInstructions,
        sliderValueGenPromptInstructions,
        textValueGenPromptInstructions,
        imageModel, 
        textModel, 
        imageParallelism 
    };
}