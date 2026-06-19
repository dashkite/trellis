import assert from "@dashkite/assert"
import { test } from "@dashkite/amen"
import print from "@dashkite/amen-console"
import { validate } from "../src"
import scenarios from "./scenario"
import prompts from "./prompt-scenarios"
import Prompts from "./prompts"
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
      result = ( validate scenarios["experiment spec"])
      assert.equal 0, result.errors.length

    test "from prompts", await do ->
      specs = new Set

      # 1. Run all generation prompts in parallel
      generationNames = ( Object.keys prompts.generation )
      generationPromises = for name in generationNames
        item = prompts.generation[name]
        promptText =
          ( Prompts["generate specification"] item.requirements )
        executePrompt promptText

      generatedResults = await Promise.all generationPromises

      # Store generated specs by name to build updates off them
      generatedSpecs = {}
      generationTests = []
      for spec, i in generatedResults
        name = generationNames[i]
        if spec?
          generatedSpecs[name] = spec

        # Push the generation test (will be pending/skipped if spec is null)
        do ( name, spec ) ->
          generationTests.push test name,
            if spec?
              ->
                serialized = ( JSON.stringify spec )
                ( assert ! ( specs.has serialized ) )
                ( specs.add serialized )
                result = ( validate spec )
                assert.equal 0, result.errors.length

      # 2. Run all update prompts in parallel
      updateNames = ( Object.keys prompts.update )
      updatePromises = for name in updateNames
        item = prompts.update[name]
        sourceSpec =
          generatedSpecs[item.source] || scenarios[item.source]
        if sourceSpec?
          promptText = ( Prompts["update specification"] sourceSpec,
            item.requirements )
          executePrompt promptText
        else
          Promise.resolve null

      updatedResults = await Promise.all updatePromises

      # Push the update tests (will be pending/skipped if spec is null)
      updateTests = []
      for spec, i in updatedResults
        name = updateNames[i]
        do ( name, spec ) ->
          updateTests.push test name,
            if spec?
              ->
                serialized = ( JSON.stringify spec )
                ( assert ! ( specs.has serialized ) )
                ( specs.add serialized )
                result = ( validate spec )
                assert.equal 0, result.errors.length

      [
        test "generated", generationTests
        test "updated", updateTests
      ]

  ]
