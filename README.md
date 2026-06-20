# Trellis

*Trellis: A minimal, normalized graph schema format optimized for LLMs and deterministic natural language translation*

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

## Purpose

Trellis provides a highly structured and normalized format for describing graph schemas. It is designed to be easily processed by Large Language Models (LLMs) and supports deterministic translation to natural language or documentation. By defining nodes, properties, and connectors with explicit constraints, Trellis ensures consistency in knowledge models.

## Installation

Install `@dashkite/trellis` using your favorite package manager:

```bash
pnpm add @dashkite/trellis
```

## Usage

### Command Line Interface

Use the CLI to validate specifications or generate Markdown documentation:

```bash
# Validate a specification file
npx trellis validate spec.yaml

# Generate Markdown documentation
npx trellis document spec.yaml
```

### API

```coffee
import { validate, document } from "@dashkite/trellis"

# Validate a specification object
result = ( validate spec )
if result.isValid
  console.log "Valid!"

# Generate Markdown documentation
markdown = ( document spec )
console.log markdown
```

## Other Resources

- [API Reference](docs/reference.md)
- [Design Document](docs/design.md)
- [Example Blog Platform Specification](docs/example/blog-platform.yaml)
- [Example Generated Documentation](docs/example/blog-platform.md)

## Status

Trellis is under active development and is not yet suitable for production use. Please report any bugs or request features on the issue tracker.
