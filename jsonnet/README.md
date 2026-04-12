# Jsonnet Configuration

Renders `~/.config/opencode/opencode.json` from Jsonnet source files.

## Files

| File | Description | Git tracked |
|------|-------------|-------------|
| `opencode.jsonnet` | Entry point | Yes |
| `opencode_models.libsonnet` | Shared model definitions (reasoning variants, GPT/Claude models) | Yes |
| `opencode_personal.libsonnet` | Personal MCP servers and providers | Yes |

Additional `opencode_*.libsonnet` files can be added for environment-specific config (gitignored).

## Rendering

Prerequisites: `jsonnet` (install via `brew install jsonnet`)

### Personal only (default)

```sh
jsonnet jsonnet/opencode.jsonnet > ~/.config/opencode/opencode.json
```

### With environment-specific config

```sh
jsonnet --tla-str env=work jsonnet/opencode.jsonnet > ~/.config/opencode/opencode.json
```

### Preview without writing

```sh
jsonnet jsonnet/opencode.jsonnet
```

## Via Makefile

`make sync-opencode` auto-detects the environment based on which libsonnet files are present.

```sh
make sync-opencode        # install (fails if opencode.json already differs)
make sync-opencode-force  # overwrite existing config
```
