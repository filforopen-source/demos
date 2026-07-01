const fs = require('fs');
const path = require('path');

const PROMPTS_DIR = path.join(__dirname, 'functions/src/common/prompts');
const REMOTE_CONFIG_PATH = path.join(__dirname, 'remoteconfig.json');

function extractStringFromTs(content) {
    const firstTick = content.indexOf('`');
    const lastTick = content.lastIndexOf('`');
    if (firstTick === -1 || lastTick === -1 || firstTick === lastTick) {
         return content;
    }
    return content.substring(firstTick + 1, lastTick);
}

function main() {
    if (!fs.existsSync(REMOTE_CONFIG_PATH)) {
        console.error(`Error: ${REMOTE_CONFIG_PATH} not found.`);
        process.exit(1);
    }

    const configRaw = fs.readFileSync(REMOTE_CONFIG_PATH, 'utf8');
    let config;
    try {
        config = JSON.parse(configRaw);
    } catch (e) {
        console.error(`Error parsing JSON in ${REMOTE_CONFIG_PATH}: ${e}`);
        process.exit(1);
    }

    const promptMappings = {
        'MODERATION_PROMPT_BRANCH_SUFFIX': 'moderation.ts',
        'POWERUP_PROMPT_BRANCH_SUFFIX': 'powerup.ts',
        'DESCRIPTION_PROMPT_BRANCH_SUFFIX': 'description.ts',
        'QUESTION_GEN_PROMPT_BRANCH_SUFFIX': 'reviserQuestion.ts',
        'SLIDER_VALUE_GEN_PROMPT_BRANCH_SUFFIX': 'reviserSlider.ts',
        'TEXT_VALUE_GEN_PROMPT_BRANCH_SUFFIX': 'reviserText.ts'
    };

    for (const [configKey, promptFilename] of Object.entries(promptMappings)) {
        const promptPath = path.join(PROMPTS_DIR, promptFilename);
        if (fs.existsSync(promptPath)) {
            const rawContent = fs.readFileSync(promptPath, 'utf8');
            const promptContent = promptFilename.endsWith('.ts') ? extractStringFromTs(rawContent) : rawContent;
            
            if (config.parameters && config.parameters[configKey]) {
                config.parameters[configKey].defaultValue.value = promptContent;
                console.log(`Injected ${promptFilename} into ${configKey}`);
            } else {
                console.warn(`Warning: ${configKey} not found in remote config parameters.`);
            }
        } else {
            console.warn(`Warning: ${promptPath} not found.`);
        }
    }

    fs.writeFileSync(REMOTE_CONFIG_PATH, JSON.stringify(config, null, 4));
}

main();
