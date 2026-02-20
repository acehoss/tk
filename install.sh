#!/usr/bin/env bash
set -euo pipefail

DEST="${1:-$HOME/.local/bin}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ ! -f "$SCRIPT_DIR/ticket/ticket" ]]; then
    echo "Initializing submodule…"
    git -C "$SCRIPT_DIR" submodule update --init
fi

mkdir -p "$DEST"

ln -sf "$SCRIPT_DIR/ticket/ticket" "$DEST/tk"
echo "Linked tk -> $DEST/tk"

for plugin in "$SCRIPT_DIR"/tk-*; do
    [[ -f "$plugin" ]] || continue
    name=$(basename "$plugin")
    ln -sf "$plugin" "$DEST/$name"
    echo "Linked $name -> $DEST/$name"
done
