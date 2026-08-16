import { isString } from "@dashkite/joy"
import pluralize from "pluralize"

plural = ( name ) -> pluralize name

nodes = ( spec ) ->
  spec?.nodes ? spec?.ontology?.nodes ? {}

node = ( spec, name ) ->
  nodes( spec )[ name ]

connectors = ( spec ) ->
  spec?.connectors ? spec?.ontology?.connectors ? {}

connector = ( spec, name ) ->
  connectors( spec )[ name ]

traversals = ( spec ) ->
  spec?.definedTraversals ? []

traversal = ( spec, name ) ->
  traversals( spec ).find ( t ) -> t.name == name

nodeTypeFromPlural = ( spec, pluralName ) ->
  for name of nodes spec
    if ( plural name ) == pluralName
      return name
  null

traversalEndType = ( spec, start, steps ) ->
  current = start
  conns = connectors spec
  for step in steps
    stepName = if isString step then step else step.name
    conn = conns[ stepName ]
    unless conn?
      throw new Error "Connector '#{stepName}' not found in ontology"
      
    connection = conn.connections[0]
    if connection.from == current
      current = connection.to
    else if connection.to == current
      current = connection.from
    else
      current = if connection.from == current then connection.to else connection.from

  current

getNodeSchema = ( spec, type ) ->
  definition = node spec, type
  if definition?
    schema = JSON.parse ( JSON.stringify definition )
    schema.type = "object"
    schema.title = type
    schema.additionalProperties = false
    delete schema.keys
    schema

getMediaType = ( spec, type ) ->
  domain = spec.authority ? "dashkite.com"
  version = spec.version ? "1.0.0"
  "application/vnd.#{domain}.#{type.toLowerCase()}+json;" +
    "charset=utf8;version=#{version}"

export {
  nodes
  node
  connectors
  connector
  traversals
  traversal
  nodeTypeFromPlural
  traversalEndType
  getNodeSchema
  getMediaType
}
