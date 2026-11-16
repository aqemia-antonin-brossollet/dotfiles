#!/usr/bin/env bash
# Coder dotfiles entrypoint. Runs on every workspace start, so must be idempotent.
set -euo pipefail

# 1. Team defaults: clone once, then follow upstream main on every start
UPSTREAM_DIR="$HOME/.local/share/coder-default-dotfiles"
if [ -d "$UPSTREAM_DIR/.git" ]; then
  git -C "$UPSTREAM_DIR" pull --ff-only --quiet || echo "upstream dotfiles: pull failed, using cached copy"
else
  mkdir -p "$(dirname "$UPSTREAM_DIR")"
  git clone --depth=1 https://github.com/Aqemia/coder-default-dotfiles "$UPSTREAM_DIR"
fi
PREFERRED_SHELL="${PREFERRED_SHELL:-zsh}" "$UPSTREAM_DIR/install.sh"

# 2. Personal layer (append-only, never overwrite rc files: keeps the # coder: markers)
if command -v mise >/dev/null; then
  mise use -g zellij@latest
fi

if ! grep -q 'PERSONAL_DOTFILES' ~/.zshrc 2>/dev/null; then
  cat >> ~/.zshrc <<'EOF'

# PERSONAL_DOTFILES
# personal aliases / env vars go here
EOF
fi
