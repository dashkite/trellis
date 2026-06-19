import yaml from "js-yaml"
import { schema } from "../../src"
import scenarios from "../scenario"

Prompts =

  "generate specification": ( requirements ) ->
    definition =
      yaml.dump schema
    example =
      yaml.dump scenarios[ "valid spec" ]
    """
    You are an expert system designer. Your task is to generate a graph schema in the new "Trellis" format.

    Here is the Trellis YAML schema specification that defines the structure:
    ---
    #{definition}
    ---

    Here is an example of a valid Trellis specification:
    ---
    #{example}
    ---

    Now, generate a valid Trellis specification from the following requirements:
    "#{requirements}"

    Use only the information provided within this prompt to generate your response.

    Do not include any explanation outside the YAML code block. Return only the YAML within a markdown code block starting with ```yaml.

    Try to generate your response as promptly as possible.
    """

  "update specification": ( specification, requirements ) ->
    definition =
      yaml.dump schema
    current =
      yaml.dump specification
    """
    You are an expert system designer. Your task is to update a graph schema in the "Trellis" format based on new requirements.

    Here is the Trellis YAML schema specification that defines the structure:
    ---
    #{definition}
    ---

    Here is the current Trellis specification:
    ---
    #{current}
    ---

    Now, update the Trellis specification based on the following requirements:
    "#{requirements}"

    Use only the information provided within this prompt to generate your response.

    Do not include any explanation outside the YAML code block. Return only the YAML within a markdown code block starting with ```yaml.

    Try to generate your response as promptly as possible.
    """

export default Prompts
