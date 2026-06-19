import assert from "@dashkite/assert"
import { test } from "@dashkite/amen"
import print from "@dashkite/amen-console"
import { validate, schema } from "../src"
import scenarios from "./scenario"
import { generateSchema } from "./helper"

do ->

  print await test "Trellis Validator", [

    test "validates a valid specification", ->
      result = ( validate scenarios["valid spec"] )
      ( assert.deepEqual result.errors, [] )

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

    test "fails when uniqueKey references undefined property", ->
      result = ( validate scenarios["invalid unique key"] )
      ( assert ! result.isValid )
      ( assert.equal result.errors.length, 1 )
      ( assert.equal result.errors[0], "Node 'author' unique key references " +
        "undefined property 'email'." )

    test "fails when required references undefined property", ->
      result = ( validate scenarios["invalid required"] )
      ( assert ! result.isValid )
      ( assert.equal result.errors.length, 1 )
      ( assert.equal result.errors[0], "Node 'author' requires " +
        "undefined property 'email'." )

    test "is able to validate real world schemas", await do ->


      [

        test "from a predefined test case", ->
          result = ( validate scenarios["experiment spec"])
          assert.equal 0, result.errors.length

        test "from a prompt", await do ->
          prompt = "An blog has posts, authors, and editors. Only authors may add posts, at which point they are the author of that post. The author of a post may edit or remove that post. An editor may update posts, but never add or remove them."
          generated = await generateSchema prompt, schema, scenarios["valid spec"]
          if generated?
            ->
              result = ( validate generated )
              assert.equal 0, result.errors.length
      ]

  ]
