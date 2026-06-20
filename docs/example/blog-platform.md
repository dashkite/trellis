# Blog Platform

## Nodes

### author

| Property | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `email` | `string` | Yes |  |
| `id` | `string` | Yes |  |

**Keys:**
- `email`

### post

| Property | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `title` | `string` | Yes |  |

## Connectors

### editor

Connects **author** to **post** with cardinality `*..*`.

#### Properties

| Property | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `assigned` | `string` | Yes |  |
