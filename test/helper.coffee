import { spawn } from "child_process"
import yaml from "js-yaml"

executePrompt = ( prompt ) ->
  try
    stdout = await new Promise ( resolve, reject ) ->
      # Spawn agy directly without a shell, ignoring stdin to prevent it
      # from blocking waiting for EOF
      child =
        spawn "agy", [
          "--model", "Gemini 3.1 Pro (Low)"
          "--print", prompt
        ], stdio: [ "ignore", "pipe", "pipe" ]

      output = ""
      errors = ""

      child.stdout.on "data", ( chunk ) ->
        output += ( chunk.toString() )

      child.stderr.on "data", ( chunk ) ->
        errors += ( chunk.toString() )

      # Set a 60-second timeout to handle locked sessions or hangs
      timer =
        setTimeout ->
          ( child.kill "SIGTERM" )
          ( reject new Error "Timeout" )
        , 60000

      child.on "close", ( code ) ->
        ( clearTimeout timer )
        if code == 0
          ( resolve output )
        else
          ( reject new Error "Process exited with code #{code}: #{errors}" )

      child.on "error", ( error ) ->
        ( clearTimeout timer )
        ( reject error )

    match =
      stdout.match /```yaml([\s\S]*?)```/i
    content =
      if match then ( match[ 1 ].trim() ) else ( stdout.trim() )
    ( yaml.load content )
  catch error
    # Fallback to null on failure or timeout
    null

export { executePrompt }
