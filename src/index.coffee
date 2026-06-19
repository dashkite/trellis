import { metaclass } from "@dashkite/joy"
import Ajv from "ajv"
import yaml from "js-yaml"
import schema from "./schema"

ajv = new Ajv

has = ( properties, name ) ->
  properties[name]?

class Validator extends ( metaclass() )
  @make: ( specification ) ->
    validator = new @
    validator.specification =
      if typeof specification == "string"
        yaml.load specification
      else
        specification
    validator

  @apply: ( specification ) -> ( @make specification ).apply()

  @getters
    isValid: -> @errors.length == 0

  constructor: ->
    super()
    @errors = []

  structure: ->
    validate = ajv.compile schema
    if ! ( validate @specification )
      for error in validate.errors
        @errors.push "Structural error: #{error.instancePath} " +
          "#{error.message}"

  connections: ->
    for name, connector of @specification.connectors
      for connection in connector.connections
        if ! ( has @specification.nodes, connection.from )
          @errors.push "Connector '#{name}' references " +
            "undefined source node '#{connection.from}'."
        if ! ( has @specification.nodes, connection.to )
          @errors.push "Connector '#{name}' references " +
            "undefined target node '#{connection.to}'."

  nodes: ->
    for name, node of @specification.nodes
      if node.required?
        for property in node.required
          if ! ( has node.properties, property )
            @errors.push "Node '#{name}' requires " +
              "undefined property '#{property}'."
      if node.uniqueKeys?
        for keyGroup in node.uniqueKeys
          for property in keyGroup
            if ! ( has node.properties, property )
              @errors.push "Node '#{name}' unique key references " +
                "undefined property '#{property}'."

  connectors: ->
    for name, connector of @specification.connectors
      if connector.required?
        for property in connector.required
          if ! ( has connector.properties, property )
            @errors.push "Connector '#{name}' requires " +
              "undefined property '#{property}'."

  apply: ->
    @structure()

    if @errors.length == 0
      @connections()
      @nodes()
      @connectors()

    @

validate = ( specification ) ->
  Validator.apply specification

export { validate, Validator }