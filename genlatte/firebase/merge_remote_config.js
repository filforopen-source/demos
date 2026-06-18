const fs = require('fs');

/**
 * Merges a local Remote Config template into a server-side template.
 * Overwrites server-side parameters with local ones, but preserves 
 * server-side parameters that are not in the local file.
 */
function mergeTemplates(serverPath, localPath) {
  try {
    const serverTemplate = JSON.parse(fs.readFileSync(serverPath, 'utf8'));
    const localTemplate = JSON.parse(fs.readFileSync(localPath, 'utf8'));

    // Ensure parameters objects exist
    serverTemplate.parameters = serverTemplate.parameters || {};
    const localParameters = localTemplate.parameters || {};

    // Merge parameters
    Object.keys(localParameters).forEach(key => {
      console.log(`Overriding/Adding parameter: ${key}`);
      serverTemplate.parameters[key] = localParameters[key];
    });

    // Write back to serverPath
    fs.writeFileSync(serverPath, JSON.stringify(serverTemplate, null, 2));
    console.log('Successfully merged templates.');
  } catch (error) {
    console.error('Error merging templates:', error.message);
    process.exit(1);
  }
}

const args = process.argv.slice(2);
if (args.length < 2) {
  console.error('Usage: node merge_remote_config.js <server_template_path> <local_template_path>');
  process.exit(1);
}

mergeTemplates(args[0], args[1]);
