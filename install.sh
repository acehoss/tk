#!/usr/bin/env bash
set -euo pipefail

DEST="${1:-$HOME/.local/bin}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$DEST"

for plugin in "$SCRIPT_DIR"/tk-*; do
    [[ -f "$plugin" ]] || continue
    name=$(basename "$plugin")
    ln -sf "$plugin" "$DEST/$name"
    echo "Linked $name -> $DEST/$name"
done
