# Jsonnet Configuration

Renders `~/.config/opencode/opencode.json` from Jsonnet source files.

## Files

| File | Description | Git tracked |
|------|-------------|-------------|
| `opencode.jsonnet` | Entry point | Yes |
| `opencode_models.libsonnet` | Shared model definitions (reasoning variants, GPT/Claude models) | Yes |
| `opencode_personal.libsonnet` | Personal MCP servers and providers | Yes |

Additional `opencode_*.libsonnet` files can be added for environment-specific config (gitignored).

## Supported Models

| Key | Name | Input $/M | Output $/M |
|-----|------|-----------|------------|
| `claude-opus-4.6` | Claude Opus 4.6 | 5.00 | 25.00 |
| `claude-sonnet-4.6` | Claude Sonnet 4.6 | 3.00 | 15.00 |
| `claude-haiku-4.5` | Claude Haiku 4.5 | 1.00 | 5.00 |
| `gpt-5.4` | GPT-5.4 | 2.50 | 15.00 |
| `gpt-5.2-pro` | GPT 5.2 Pro | 21.00 | 168.00 |
| `gpt-5.3-codex` | GPT 5.3 Codex | 1.75 | 14.00 |

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
