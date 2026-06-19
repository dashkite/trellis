import yaml from "js-yaml"
import { schema } from "../src"
import scenarios from "./scenario"

Prompts =

  "generate specification": ( requirements ) ->
    schemaYaml = ( yaml.dump schema )
    exampleYaml = ( yaml.dump scenarios["valid spec"] )
    """
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
    "#{requirements}"

    Use only the information provided within this prompt to generate your response.

    Do not include any explanation outside the YAML code block. Return only the YAML within a markdown code block starting with ```yaml.

    Try to generate your response as promptly as possible.
    """

  "update specification": ( currentSpec, requirements ) ->
    schemaYaml = ( yaml.dump schema )
    currentYaml = ( yaml.dump currentSpec )
    """
    You are an expert system designer. Your task is to update a graph schema in the "Trellis" format based on new requirements.

    Here is the Trellis YAML schema specification that defines the structure:
    ---
    #{schemaYaml}
    ---

    Here is the current Trellis specification:
    ---
    #{currentYaml}
    ---

    Now, update the Trellis specification based on the following requirements:
    "#{requirements}"

    Use only the information provided within this prompt to generate your response.

    Do not include any explanation outside the YAML code block. Return only the YAML within a markdown code block starting with ```yaml.

    Try to generate your response as promptly as possible.
    """

export default Prompts
