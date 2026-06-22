Trellis Schema
==============

[Nodes](#nodes) | [Connectors](#connectors) | [Nodes Entry](#nodes-entry) | [Properties (Nodes Entry)](#properties-nodes-entry) | [Required (Nodes Entry)](#required-nodes-entry) | [Keys](#keys) | [Keys Items](#keys-items) | [Connectors Entry](#connectors-entry) | [Properties (Connectors Entry)](#properties-connectors-entry) | [Required (Connectors Entry)](#required-connectors-entry) | [Connections](#connections) | [Connections Items](#connections-items) | [Cardinality](#cardinality)

Trellis is a minimal, normalized graph schema format optimized for LLMs and deterministic natural language translation.

| Name | Value |
| --- | --- |
| Schema URI | http://json-schema.org/draft-07/schema# |
| Type | Object |
| Required Properties | [Name](#name), [Nodes](#nodes), [Connectors](#connectors) |

### Properties

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
| Additional Properties | [Nodes Entry](#nodes-entry) |

Connectors
----------

Map of Connector definitions, representing the relationship types in the schema.

| Name | Value |
| --- | --- |
| Type | Object |
| Additional Properties | [Connectors Entry](#connectors-entry) |

Nodes Entry
-----------

A definition of an entity type.

| Name | Value |
| --- | --- |
| Type | Object |
| Required Properties | [Properties](#properties) |

### Properties

#### Description

A human-readable description of the node type.

| Name | Value |
| --- | --- |
| Type | String |

#### Properties

Standard JSON Schema property definitions for the node.

See: [Properties (Nodes Entry)](#properties-nodes-entry)

#### Required

List of property names that must be defined for each instance of this node.

See: [Required (Nodes Entry)](#required-nodes-entry)

#### Keys

Array of unique keys representing semantic uniqueness constraints (supports composite keys).

See: [Keys](#keys)

Properties (Nodes Entry)
------------------------

Standard JSON Schema property definitions for the node.

| Name | Value |
| --- | --- |
| Type | Object |
| Additional Properties | [JSON Schema](http://json-schema.org/draft-07/schema#) |

Required (Nodes Entry)
----------------------

List of property names that must be defined for each instance of this node.

| Name | Value |
| --- | --- |
| Type | Array |
| Items | Type: String |

Keys
----

Array of unique keys representing semantic uniqueness constraints (supports composite keys).

| Name | Value |
| --- | --- |
| Type | Array |

See: [Keys Items](#keys-items)

Keys Items
----------

| Name | Value |
| --- | --- |
| Type | Array |
| Items | Type: String |

Connectors Entry
----------------

A definition of a relationship type.

| Name | Value |
| --- | --- |
| Type | Object |
| Required Properties | [Connections](#connections) |

### Properties

#### Description

A human-readable description of the connector type.

| Name | Value |
| --- | --- |
| Type | String |

#### Properties

Standard JSON Schema property definitions for the connector.

See: [Properties (Connectors Entry)](#properties-connectors-entry)

#### Required

List of property names that must be defined for each instance of this connector.

See: [Required (Connectors Entry)](#required-connectors-entry)

#### Connections

List of directed connection rules that this connector establishes.

See: [Connections](#connections)

Properties (Connectors Entry)
-----------------------------

Standard JSON Schema property definitions for the connector.

| Name | Value |
| --- | --- |
| Type | Object |
| Additional Properties | [JSON Schema](http://json-schema.org/draft-07/schema#) |

Required (Connectors Entry)
---------------------------

List of property names that must be defined for each instance of this connector.

| Name | Value |
| --- | --- |
| Type | Array |
| Items | Type: String |

Connections
-----------

List of directed connection rules that this connector establishes.

| Name | Value |
| --- | --- |
| Type | Array |

See: [Connections Items](#connections-items)

Connections Items
-----------------

A directed connection rule between two node types.

| Name | Value |
| --- | --- |
| Type | Object |
| Required Properties | [From](#from), [To](#to), [Cardinality](#cardinality) |
| Additional Properties | false |

### Properties

#### Description

A human-readable description of the connection rule.

| Name | Value |
| --- | --- |
| Type | String |

#### From

The source node type of the connection.

| Name | Value |
| --- | --- |
| Type | String |

#### To

The target node type of the connection.

| Name | Value |
| --- | --- |
| Type | String |

#### Cardinality

The cardinality of the connection (e.g. '1', '\*', '0..\*', '1..\*').

See: [Cardinality](#cardinality)

Cardinality
-----------

The cardinality of the connection (e.g. '1', '\*', '0..\*', '1..\*').

| Name | Value |
| --- | --- |
| Type | String |
| Pattern | `^(\*\|\+\|\?\|\d+)(\.\.(\*\|\+\|\?\|\d+))?$` |