import { spawn } from "child_process"
import yaml from "js-yaml"

generateSchema = ( prompt, schema, example ) ->
  schemaYaml = yaml.dump schema
  exampleYaml = yaml.dump example

  fullPrompt = """
    You are an expert system designer. Your task is to generate a graph schema in the new "Trellis" format.

    Here is the Trellis YAML schema specification that defines the structure:
    ---
    #{schemaYaml}
    ---

    Here is an example of a valid Trellis specification:
    ---
    #{exampleYaml}
    ---

    Now, generate a valid Trellis specification from the following requirements:
    "#{prompt}"

    Use only the information provided within this prompt to generate your response.

    Do not include any explanation outside the YAML code block. Return only the YAML within a markdown code block starting with ```yaml.

    Try to generate your response as promptly as possible.
  """

  try
    stdout = await new Promise ( resolve, reject ) ->
      # Spawn agy directly without a shell, ignoring stdin to prevent it from blocking waiting for EOF
      child = spawn "agy", [ "--model", "Gemini 3.1 Pro (Low)", "--print", fullPrompt ],
        stdio: [ "ignore", "pipe", "pipe" ]

      output = ""
      errorOutput = ""

      child.stdout.on "data", ( chunk ) ->
        output += chunk.toString()

      child.stderr.on "data", ( chunk ) ->
        errorOutput += chunk.toString()

      # Set a 30-second timeout to handle locked sessions or hangs
      # (agy takes a while to return a response...)
      timer = setTimeout ->
        child.kill "SIGTERM"
        reject new Error "Timeout"
      , 30000

      child.on "close", ( code ) ->
        clearTimeout timer
        if code == 0
          resolve output
        else
          reject new Error "Process exited with code #{code}: #{errorOutput}"

      child.on "error", ( error ) ->
        clearTimeout timer
        reject error

    match = stdout.match /```yaml([\s\S]*?)```/i
    yamlContent = if match then match[1].trim() else stdout.trim()
    yaml.load yamlContent
  catch error
    # Fallback to the pre-cached mock scenario on failure or timeout
    null

export { generateSchema }
