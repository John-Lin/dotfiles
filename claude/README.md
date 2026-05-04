# Claude Code Configuration

This directory contains configuration for [Claude Code](https://claude.ai/code).

Run `make sync-claude` from the repo root to install everything.

`sync-claude` is conservative: if `~/.claude/CLAUDE.md`, `~/.claude/settings.json`, or the target symlinks already contain unmanaged local contents, it stops instead of overwriting them. Use `make sync-claude-force` when you want to replace local contents explicitly.

## Directory Layout

```
claude/
├── .claude/
│   ├── CLAUDE.base.md              # Shared engineering principles (tracked)
│   ├── CLAUDE.personal.md          # Your personal instructions (gitignored)
│   ├── CLAUDE.personal.md.example  # Template for the above
│   ├── agents/                     # Specialized subagents → ~/.claude/agents/
│   ├── commands/                   # Custom slash commands → ~/.claude/commands/
│   └── skills/                     # Reusable skills → ~/.claude/skills/
├── claude_settings.json.template          # Base settings (tracked)
├── claude_settings.personal.json          # Your personal settings (gitignored)
└── claude_settings.personal.json.example # Template for the above
```

`sync-claude` symlinks `agents/`, `commands/`, and `skills/` directly into `~/.claude/`.
`CLAUDE.md` and `settings.json` are generated files — do not edit them directly.

## Personal Configuration

Two files let you override shared config without touching tracked files.
Both are gitignored so your changes stay local.

### CLAUDE.personal.md — instructions for Claude

Controls how Claude behaves: your name, preferred language, custom rules, safe words, etc.

```bash
cp claude/.claude/CLAUDE.personal.md.example claude/.claude/CLAUDE.personal.md
# Edit to taste, then:
make sync-claude
```

`sync-claude` concatenates `CLAUDE.base.md` + `CLAUDE.personal.md` → `~/.claude/CLAUDE.md`.
Personal content appends after the base, so your rules take precedence.
If `~/.claude/CLAUDE.md` already exists with different contents, `sync-claude` stops instead of overwriting it.

### claude_settings.personal.json — settings overrides

Controls hooks, status line, MCP plugins, and other Claude Code settings.
`sync-claude` deep-merges this on top of `claude_settings.json.template` using `jq`.
If `~/.claude/settings.json` already exists with different contents, `sync-claude` stops instead of overwriting it.

```bash
cp claude/claude_settings.personal.json.example claude/claude_settings.personal.json
# Edit to taste, then:
make sync-claude
```

Common things to put here:

**Completion sound hook**

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "paplay /usr/share/sounds/freedesktop/stereo/complete.oga"
          }
        ]
      }
    ]
  }
}
```

> macOS: replace with `afplay /System/Library/Sounds/Glass.aiff`

**Status line**

```json
{
  "statusLine": {
    "type": "command",
    "command": "bunx -y ccstatusline@latest"
  }
}
```

See the [Claude Code settings reference](https://docs.anthropic.com/en/docs/claude-code/settings) for all available keys.

## agents / commands / skills

These are symlinked as-is into `~/.claude/`. Add files here and re-run `make sync-claude`
(or just restart Claude Code — it picks up symlinked directories automatically).
If the destination already contains unmanaged symlinks or files, `sync-claude` stops and asks you to move them away or run `make sync-claude-force`.

| Directory  | What goes here                          |
|------------|-----------------------------------------|
| `agents/`  | Subagent prompt files (`*.md`) — see source mapping below |
| `commands/`| Slash command prompts (`*.md`)          |
| `skills/`  | Multi-file reusable skills (`*/SKILL.md`)|

### Subagent sources

All subagents under `agents/` are sourced from [wshobson/agents](https://github.com/wshobson/agents). Upstream paths for refresh reference:

| Local file | Upstream path |
|---|---|
| `architect-review.md`     | `plugins/comprehensive-review/agents/architect-review.md` |
| `c-pro.md`                | `plugins/systems-programming/agents/c-pro.md` |
| `code-reviewer.md`        | `plugins/code-refactoring/agents/code-reviewer.md` |
| `debugger.md`             | `plugins/debugging-toolkit/agents/debugger.md` |
| `golang-pro.md`           | `plugins/systems-programming/agents/golang-pro.md` |
| `prompt-engineer.md`      | `plugins/llm-application-dev/agents/prompt-engineer.md` |
| `python-pro.md`           | `plugins/python-development/agents/python-pro.md` |
| `terraform-specialist.md` | `plugins/cloud-infrastructure/agents/terraform-specialist.md` |
| `typescript-pro.md`       | `plugins/javascript-typescript/agents/typescript-pro.md` |

Note: the `model:` field is overridden locally (not always matching upstream) — see each file's frontmatter.

### Imported skill sources

Some skills under `skills/` are imported from [mitsuhiko/agent-stuff](https://github.com/mitsuhiko/agent-stuff) for reuse here.
Use this table as the refresh/source-of-truth mapping.
The current import baseline is upstream commit `b861028c706edf3e3f983cde09dd8cc8549ec948`.

| Local skill | Upstream path | Notes |
|---|---|---|
| `commit` | `skills/commit` | Imported as-is. |
| `native-web-search` | `skills/native-web-search` | Imported as-is. |
| `pi-share` | `skills/pi-share` | Usage examples are adjusted locally to run from the skill directory in this dotfiles layout. |
| `summarize` | `skills/summarize` | Imported as-is. |
| `update-changelog` | `skills/update-changelog` | Imported as-is. |
| `uv` | `skills/uv` | Imported as-is. |
