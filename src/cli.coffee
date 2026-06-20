import FS from "node:fs"
import Path from "node:path"
import { program } from "commander"
import yaml from "js-yaml"
import { validate, document } from "./index"

loadSpecification = ( filepath ) ->
  try
    content =
      FS.readFileSync filepath, "utf8"
    yaml.load content
  catch error
    console.error "Error reading specification file: #{error.message}"
    process.exit 1

program
  .version do ({ path, json, pkg } = {}) ->
    path = Path.join __dirname, "..", "..", "..", "package.json"
    json = FS.readFileSync path, "utf8"
    pkg = JSON.parse json
    pkg.version
  .enablePositionalOptions()

program
  .command "validate"
  .description "Validate a Trellis specification"
  .argument "<filepath>", "Path to the Trellis specification file"
  .action ( filepath ) ->
    spec =
      loadSpecification filepath
    result =
      validate spec
    if result.isValid
      console.log "Trellis specification is valid."
      process.exit 0
    else
      console.error "Trellis specification is invalid:"
      for error in result.errors
        console.error "- #{error}"
      process.exit 1

program
  .command "document"
  .description "Generate Markdown documentation from a Trellis specification"
  .argument "<filepath>", "Path to the Trellis specification file"
  .action ( filepath ) ->
    spec =
      loadSpecification filepath
    markdown =
      document spec
    console.log markdown
    process.exit 0

program.parseAsync()
