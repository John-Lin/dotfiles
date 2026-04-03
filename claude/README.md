# Claude Code Configuration

This directory contains configuration for [Claude Code](https://claude.ai/code).

Run `make sync-claude` from the repo root to install everything.

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

### claude_settings.personal.json — settings overrides

Controls hooks, status line, MCP plugins, and other Claude Code settings.
`sync-claude` deep-merges this on top of `claude_settings.json.template` using `jq`.

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

| Directory  | What goes here                          |
|------------|-----------------------------------------|
| `agents/`  | Subagent prompt files (`*.md`)          |
| `commands/`| Slash command prompts (`*.md`)          |
| `skills/`  | Multi-file reusable skills (`*/SKILL.md`)|
