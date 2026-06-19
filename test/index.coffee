import assert from "@dashkite/assert"
import { test } from "@dashkite/amen"
import print from "@dashkite/amen-console"
import { validate } from "../src"
import scenarios from "./scenario"
import prompts from "./prompt/scenarios"
import Prompts from "./prompt"
import { executePrompt } from "./helper"

do ->

  print await test "Trellis Validator", [

    test "validates a valid specification", ->
      result = ( validate scenarios["valid spec"] )
      ( assert.equal 0, result.errors.length )

    test "fails on invalid structure", ->
      result = ( validate scenarios["invalid structure"] )
      ( assert ! result.isValid )
      ( assert.equal result.errors.length, 1 )

    test "fails on reference to undefined node", ->
      result = ( validate scenarios["invalid node ref"] )
      ( assert ! result.isValid )
      ( assert.equal result.errors.length, 1 )
      ( assert.equal result.errors[0], "Connector 'editor' references " +
        "undefined target node 'non-existent-node'." )

    test "fails when key references undefined property", ->
      result = ( validate scenarios["invalid unique key"] )
      ( assert ! result.isValid )
      ( assert.equal result.errors.length, 1 )
      ( assert.equal result.errors[0], "Node 'author' key references " +
        "undefined property 'email'." )

    test "fails when required references undefined property", ->
      result = ( validate scenarios["invalid required"] )
      ( assert ! result.isValid )
      ( assert.equal result.errors.length, 1 )
      ( assert.equal result.errors[0], "Node 'author' requires " +
        "undefined property 'email'." )

    test "from a predefined test case", ->
      result = ( validate scenarios["experiment spec"] )
      ( assert.equal 0, result.errors.length )

    test "from prompts", await do ->
      specifications = new Set

      generate = ( items ) ->
        names = ( Object.keys items )
        promises = for name in names
          prompt =
            Prompts[ "generate specification" ] items[ name ].requirements
          ( executePrompt prompt )
        results = await ( Promise.all promises )
        registry = {}
        for specification, i in results
          if specification?
            registry[ names[ i ]] = specification
        registry

      update = ( items, base ) ->
        names = ( Object.keys items )
        promises = for name in names
          item = items[ name ]
          specification =
            base[ item.source ] || scenarios[ item.source ]
          if specification?
            prompt =
              Prompts[ "update specification" ] specification,
                item.requirements
            ( executePrompt prompt )
          else
            ( Promise.resolve null )
        results = await ( Promise.all promises )
        registry = {}
        for specification, i in results
          if specification?
            registry[ names[ i ]] = specification
        registry

      build = ( items, registry ) ->
        for name, item of items
          specification =
            registry[ name ]
          do ( name, specification ) ->
            test name,
              if specification?
                ->
                  serialized = ( JSON.stringify specification )
                  ( assert ! ( specifications.has serialized ))
                  ( specifications.add serialized )
                  result = ( validate specification )
                  ( assert.equal 0, result.errors.length )

      base = await ( generate prompts.generation )
      updated = await ( update prompts.update, base )

      [
        test "generated", ( build prompts.generation, base )
        test "updated", ( build prompts.update, updated )
      ]

  ]
