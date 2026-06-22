# Blog Platform

## Nodes

### author

An author of the blog.

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `email` | `string` | Yes |  |
| `id` | `string` | Yes |  |

**Keys:**

*   `email`

### post

A blog post.

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `title` | `string` | Yes |  |

## Connectors

### editor

Manages post editor assignments.

Connects **author** to **post** with cardinality `*..*`. Links authors to their posts.

#### Properties

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `assigned` | `string` | Yes |  |

