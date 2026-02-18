---
name: ticket
description: "Git-backed issue tracker for AI agents. Use when a `.tickets` directory exists at the project root or when the user requests. Supports dependency tracking, status management, and querying."
---

# Ticket System

This project uses `tk` for task management and notes. This tool stores tickets as markdown files with YAML frontmatter. When working on tickets, be sure to mark them in progress and add notes to them as you learn things and make progress. Check with the user before closing tickets. **Do not close tickets without user approval.**

When creating tickets, describe the issue/feature, including a list of specific requirements, acceptance criteria, and test strategy. If you are unsure of any details, ask the user. 

Always use the `tk` CLI to modify tickets. You may search for and read the tickets files, but don't write them directly.

## Bootstrap

Before using, verify the tool is available:

```bash
tk help
```

If `tk` is not found, install it locally:

```bash
mkdir -p .claude/scripts
curl -fsSL https://raw.githubusercontent.com/wedow/ticket/refs/heads/master/ticket -o .claude/scripts/tk
chmod +x .claude/scripts/tk
.claude/scripts/tk help
```

If installation fails (network issues, etc.), a copy of the tk script is embedded with this skill.

## Usage

Run `tk help` to see available commands. The help output provides complete usage documentation.

## Common Workflows

- **View work in a tree** `tk tree`
- **Archive closed work** `tk archive`
- **View ready work**: `tk ready` lists tickets with resolved dependencies
- **View blocked work**: `tk blocked` lists tickets awaiting dependencies
- **Start work**: `tk start <id>` before beginning a task
- **Complete work**: `tk close <id>` when finished
- **Add context**: `tk add-note <id> "note text"` to append timestamped notes
