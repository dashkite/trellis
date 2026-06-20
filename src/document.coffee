import { titleCase, uncase } from "@dashkite/joy"
import yaml from "js-yaml"

formatType = ( property ) ->
  type = property.type || ""
  if property.format?
    "#{type} (format: #{property.format})"
  else
    type

formatDescription = ( property ) ->
  parts = []
  if property.description?
    parts.push property.description
  if property.enum?
    enumList = property.enum.map( (v) -> "`#{v}`" ).join ", "
    parts.push "Must be one of: #{enumList}."
  if property.default?
    parts.push "Default: `#{property.default}`."
  parts.join " "

renderPropertiesTable = ( properties, requiredList = [] ) ->
  names = ( Object.keys properties ).sort()
  if names.length == 0
    return "This node has no properties."

  lines = []
  lines.push "| Property | Type | Required | Description |"
  lines.push "| :--- | :--- | :--- | :--- |"

  for name in names
    property = properties[name]
    typeStr = ( formatType property )
    isRequired = if name in requiredList then "Yes" else "No"
    descStr = ( formatDescription property )
    lines.push "| `#{name}` | `#{typeStr}` | #{isRequired} | #{descStr} |"

  lines.join "\n"

renderNodes = ( nodes ) ->
  lines = []
  lines.push "## Nodes"

  names = ( Object.keys nodes ).sort()
  for name in names
    node = nodes[name]
    lines.push ""
    lines.push "### #{name}"
    if node.description?
      lines.push ""
      lines.push node.description
    lines.push ""
    lines.push ( renderPropertiesTable node.properties, node.required )

    if node.keys? && node.keys.length > 0
      lines.push ""
      lines.push "**Keys:**"
      for keyGroup in node.keys
        keyStr = keyGroup.join ", "
        lines.push "- `#{keyStr}`"

  lines.join "\n"

renderConnectors = ( connectors ) ->
  lines = []
  lines.push "## Connectors"

  names = ( Object.keys connectors ).sort()
  for name in names
    connector = connectors[name]
    lines.push ""
    lines.push "### #{name}"
    if connector.description?
      lines.push ""
      lines.push connector.description

    if connector.connections? && connector.connections.length > 0
      lines.push ""
      for connection in connector.connections
        desc =
          if connection.description?
            " " + connection.description
          else
            ""
        text =
          "Connects **#{connection.from}** to **#{connection.to}** " +
          "with cardinality `#{connection.cardinality}`.#{desc}"
        lines.push text

    hasProps =
      connector.properties? &&
      ( Object.keys connector.properties ).length > 0
    if hasProps
      lines.push ""
      lines.push "#### Properties"
      lines.push ""
      table =
        renderPropertiesTable connector.properties, connector.required
      lines.push table

  lines.join "\n"

document = ( specification ) ->
  spec =
    if typeof specification == "string"
      yaml.load specification
    else
      specification

  lines = []

  title = ( titleCase uncase spec.name )
  lines.push "# #{title}"

  if spec.nodes? && ( Object.keys spec.nodes ).length > 0
    lines.push ""
    lines.push ( renderNodes spec.nodes )

  if spec.connectors? && ( Object.keys spec.connectors ).length > 0
    lines.push ""
    lines.push ( renderConnectors spec.connectors )

  ( lines.join "\n" ) + "\n"

export { document }
