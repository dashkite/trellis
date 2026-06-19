import { spawn } from "child_process"
import yaml from "js-yaml"

executePrompt = ( promptText ) ->
  try
    stdout = await new Promise ( resolve, reject ) ->
      # Spawn agy directly without a shell, ignoring stdin to prevent it from blocking waiting for EOF
      child = spawn "agy", [ "--model", "Gemini 3.1 Pro (Low)", "--print", promptText ],
        stdio: [ "ignore", "pipe", "pipe" ]

      output = ""
      errorOutput = ""

      child.stdout.on "data", ( chunk ) ->
        output += chunk.toString()

      child.stderr.on "data", ( chunk ) ->
        errorOutput += chunk.toString()

      # Set a 60-second timeout to handle locked sessions or hangs
      timer = setTimeout ->
        child.kill "SIGTERM"
        reject new Error "Timeout"
      , 60000

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
    # Fallback to null on failure or timeout
    null

export { executePrompt }
