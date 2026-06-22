Trellis Schema
==============

[Nodes](#nodes) | [Connectors](#connectors)

Trellis is a minimal, normalized graph schema format optimized for LLMs and deterministic natural language translation.

| Name | Value |
| --- | --- |
| Type | Object |
| Required Properties | [Name](#name), [Nodes](#nodes), [Connectors](#connectors) |

### Properties

#### $Schema

The JSON Schema URI referencing the schema definition version.

| Name | Value |
| --- | --- |
| Type | String |

#### Name

The unique name of the specification.

| Name | Value |
| --- | --- |
| Type | String |

#### Nodes

Map of Node definitions, representing the entity types in the schema.

See: [Nodes](#nodes)

#### Connectors

Map of Connector definitions, representing the relationship types in the schema.

See: [Connectors](#connectors)

Nodes
-----

Map of Node definitions, representing the entity types in the schema.

| Name | Value |
| --- | --- |
| Type | Object |
| Additional Properties | Type: Object; Required Properties: [Properties](#properties) |

Connectors
----------

Map of Connector definitions, representing the relationship types in the schema.

| Name | Value |
| --- | --- |
| Type | Object |
| Additional Properties | Type: Object; Required Properties: [Connections](#connections) |