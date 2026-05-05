# Jsonnet Configuration

Renders `~/.config/opencode/opencode.json` from Jsonnet source files.

## Files

| File | Description | Git tracked |
|------|-------------|-------------|
| `opencode.jsonnet` | Entry point that merges the public base config with an optional private work overlay | Yes |
| `opencode_models.libsonnet` | Shared model definitions (reasoning variants, GPT/Claude models) | Yes |
| `opencode_personal.libsonnet` | Public personal providers and MCP servers | Yes |

Work-only config is kept outside this repo. When `env=work`, Jsonnet expects a private `opencode_work.libsonnet` to be available through the Jsonnet library path.

## Supported Models

| Key | Name | Input $/M | Output $/M |
|-----|------|-----------|------------|
| `claude-opus-4.6` | Claude Opus 4.6 | 5.00 | 25.00 |
| `claude-sonnet-4.6` | Claude Sonnet 4.6 | 3.00 | 15.00 |
| `claude-haiku-4.5` | Claude Haiku 4.5 | 1.00 | 5.00 |
| `gpt-5.4` | GPT-5.4 | 2.50 | 15.00 |
| `gpt-5.5` | GPT-5.5 | 5.00 | 30.00 |
| `gpt-5.2-pro` | GPT 5.2 Pro | 21.00 | 168.00 |
| `gpt-5.3-codex` | GPT 5.3 Codex | 1.75 | 14.00 |

## Rendering

Prerequisites: `jsonnet` (install via `brew install jsonnet`)

### Personal only (default)

```sh
jsonnet jsonnet/opencode.jsonnet > ~/.config/opencode/opencode.json
```

### With private work overlay

The private config directory must contain `opencode_work.libsonnet`.

```sh
jsonnet -J /path/to/private-opencode-config -J jsonnet \
  --tla-str env=work jsonnet/opencode.jsonnet > ~/.config/opencode/opencode.json
```

### Preview without writing

```sh
jsonnet jsonnet/opencode.jsonnet
jsonnet -J /path/to/private-opencode-config -J jsonnet --tla-str env=work jsonnet/opencode.jsonnet
```

## Via Makefile

`make sync-opencode` installs the personal config by default. If `OPENCODE_WORK_CONFIG` is set, it switches to `env=work` and adds that directory to the Jsonnet library path.

```sh
make sync-opencode
OPENCODE_WORK_CONFIG=/path/to/private-opencode-config make sync-opencode
make sync-opencode-force
OPENCODE_WORK_CONFIG=/path/to/private-opencode-config make sync-opencode-force
```
