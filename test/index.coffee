import assert from "@dashkite/assert"
import { test } from "@dashkite/amen"
import print from "@dashkite/amen-console"
import { validate, document } from "../src"
import scenarios from "./scenario"

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

    test "generates markdown documentation for a valid specification", ->
      markdown = ( document scenarios["valid spec"] )
      ( assert.equal true, ( markdown.includes "# Blog Platform" ) )
      ( assert.equal true, ( markdown.includes "An author of the blog." ) )
      ( assert.equal true, ( markdown.includes "A blog post." ) )
      expectedDesc =
        "Manages post editor assignments."
      ( assert.equal true, ( markdown.includes expectedDesc ) )
      expectedTable =
        "| `email` | `string` | Yes |"
      ( assert.equal true, ( markdown.includes expectedTable ) )
      expectedConnection =
        "Connects **author** to **post** with cardinality `*..*`. " +
        "Links authors to their posts."
      ( assert.equal true, ( markdown.includes expectedConnection ) )

  ]
