# API Reference

## validate

$validate: specification \to result$

Validates a Trellis specification object or YAML string. It compiles the
specification against the Trellis JSON schema and verifies connection, key,
and required property constraints.

### Example

```coffee
import assert from "@dashkite/assert"
import { validate } from "@dashkite/trellis"

result = ( validate specification )
assert.equal result.isValid, true
```

## document

$document: specification \to markdown$

Generates a clean and deterministic Markdown document that describes the
Trellis specification.

### Example

```coffee
import assert from "@dashkite/assert"
import { document } from "@dashkite/trellis"

markdown = ( document specification )
assert.equal ( markdown.includes "# Blog Platform" ), true
```
