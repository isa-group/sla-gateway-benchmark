var jsyaml = require('js-yaml');
var fs = require('fs');
var path = require('path');

var generatedLocation = process.env.GENERATED_LOCATION;
var SLAsToProduce = process.env.SLAS_TO_PRODUCE;
var apikeysPerSLA = process.env.APIKEYS_PER_SLA;

if (SLAsToProduce == undefined) {
    console.log("SLAS_TO_PRODUCE not defined");
    process.exit(1)
}
if (generatedLocation == undefined) {
    console.log("GENERATED_LOCATION not defined");
    process.exit(1)
}
if (SLAsToProduce % 2 != 0) {
    console.log("SLAS_TO_PRODUCE must be even")
    process.exit(1)
}
if (apikeysPerSLA == undefined) {
    console.log("APIKEYS_PER_SLA not defined")
    process.exit(1)
}

/**
 * Generates a list of API keys.
 * @param {int} apikeysPerSLA - The number of API keys each generated SLA should have.
 * @param {string} plan - Plan type, one of "basic" or "pro".
 * @param {int} slaCounter - SLA counter, an integer between 1 and the total number of SLAs to generate.
 */
function generateAPIkeyArray(apikeysPerSLA, plan, slaCounter) {
    var res = [];
    for (var i = 1; i <= apikeysPerSLA; i++) {
        // proplan-sla-apikey
        res.push(`${plan}plan-sla${slaCounter}-apikey${i}`)
    }
    return res
}

var plan = "basic";
for (var i = 1; i <= SLAsToProduce; i++) {

    // Half will be "basic" and the other half "pro"
    if (i > SLAsToProduce / 2) {
        plan = "pro"
    }

    // Load template
    var slaTemplate = fs.readFileSync(path.join('', `template_${plan}.yaml`), 'utf8');
    slaTemplate = jsyaml.load(slaTemplate);

    // Add customer id and apikeys to template
    slaTemplate.context.id = `${plan}Customer${i}`
    slaTemplate.context.apikeys = generateAPIkeyArray(apikeysPerSLA, plan, i)

    // Save template as new file
    fs.writeFileSync(`${generatedLocation}/${plan}${i}.yaml`, jsyaml.dump(slaTemplate), 'utf8');

}