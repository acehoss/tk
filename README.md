# ticket-extensions

Plugins for [tk](https://github.com/wedow/ticket) (v0.3.2+) that add visualization commands.

## Plugins

### tk tree

Show the parent/child ticket hierarchy as an ASCII tree. Tickets are sorted by status (open before closed), priority, then ID.

```
tk tree              # full tree from all roots
tk tree <id>         # subtree rooted at a specific ticket
```

### tk deps-mermaid

Generate a Mermaid `graph TD` diagram of ticket dependency relationships. Useful for pasting into markdown or rendering with tools that support Mermaid.

```
tk deps-mermaid              # all tickets
tk deps-mermaid <id> [id...] # subgraph reachable from given roots
```

## Install

Run the install script to symlink the plugins into a directory on your PATH:

```bash
./install.sh                    # default: ~/.local/bin
./install.sh /usr/local/bin     # or specify a directory
```

Or manually copy/symlink the `tk-*` files into any directory on your PATH.

## Requirements

- [tk](https://github.com/wedow/ticket) v0.3.2+ (plugin system support)
- bash, awk, find (standard unix tools)
