# Blog Platform

This is an example specification for a blogging platform, detailing nodes for authors and posts, along with an editor connector to manage post assignments.

```yaml
name: blog-platform
nodes:
  author:
    properties:
      id:
        type: string
      email:
        type: string
    required:
      - id
      - email
    keys:
      - - email
  post:
    properties:
      title:
        type: string
    required:
      - title
connectors:
  editor:
    properties:
      assigned:
        type: string
    required:
      - assigned
    connections:
      - from: author
        to: post
        cardinality: "*..*"
```

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
