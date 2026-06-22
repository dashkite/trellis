import { titleCase, uncase } from "@dashkite/joy"
import yaml from "js-yaml"
import TurndownService from "turndown"
import template from "./templates/document"

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

buildViewModel = ( spec ) ->
  name: ( titleCase ( uncase spec.name ))
  nodes: if spec.nodes?
    nodeNames = ( Object.keys spec.nodes ).sort()
    for nodeName in nodeNames
      node = spec.nodes[nodeName]
      name: nodeName
      description: node.description
      properties: if node.properties?
        propNames = ( Object.keys node.properties ).sort()
        for propName in propNames
          prop = node.properties[propName]
          name: propName
          type: ( formatType prop )
          required: if node.required? && propName in node.required then "Yes" else "No"
          description: ( formatDescription prop )
      keys: node.keys
  connectors: if spec.connectors?
    connNames = ( Object.keys spec.connectors ).sort()
    for connName in connNames
      conn = spec.connectors[connName]
      name: connName
      description: conn.description
      connections: conn.connections
      properties: if conn.properties?
        propNames = ( Object.keys conn.properties ).sort()
        for propName in propNames
          prop = conn.properties[propName]
          name: propName
          type: ( formatType prop )
          required: if conn.required? && propName in conn.required then "Yes" else "No"
          description: ( formatDescription prop )

document = ( specification ) ->
  spec =
    if typeof specification == "string"
      yaml.load specification
    else
      specification

  viewModel = ( buildViewModel spec )
  html = ( template { spec: viewModel } )

  turndown = ( new TurndownService headingStyle: "atx", emDelimiter: "_" )
  ( turndown.addRule 'table',
    filter: 'table'
    replacement: ( content, node ) ->
      rows = ( Array.from ( node.querySelectorAll "tr" ))
      mdRows = []
      for row in rows
        cells = ( Array.from ( row.querySelectorAll "th, td" ))
        mdCells = []
        for cell in cells
          htmlContent = ( cell.innerHTML.replace /<br\s*\/?>/gi, '^^BR^^' )
          text =
            ( turndown.turndown htmlContent )
              .trim()
          text = ( text.replace /\^\^BR\^\^/g, '<br>' )
          text = ( text.replace /\|/g, '\\|' )
          text = ( text.replace /\r?\n/g, ' ' )
          ( mdCells.push text )
        ( mdRows.push "| " + ( mdCells.join " | " ) + " |" )
      if mdRows.length > 0
        headerRow = mdRows[ 0 ]
        cellsCount =
          ( Array.from ( rows[ 0 ].querySelectorAll "th, td" )).length
        separatorCells = ( "---" for i in [ 1..cellsCount ] )
        separatorRow = "| " + ( separatorCells.join " | " ) + " |"
        ( mdRows.splice 1, 0, separatorRow )
      "\n\n" + ( mdRows.join "\n" ) + "\n\n" )

  markdown = ( turndown.turndown html )
  markdown = ( markdown.replace /`([^`]+)`/g, ( match, p1 ) ->
    "`" + ( p1.replace /\\([*_`~\\#+\-.!{}()\[\]])/g, "$1" ) + "`"
  )
  markdown + "\n"

export { document }
