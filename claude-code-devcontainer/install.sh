#!/bin/bash
set -euo pipefail

SOURCE="${BASH_SOURCE[0]}"
while [[ -L "$SOURCE" ]]; do
  DIR="$(cd "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ "$SOURCE" != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIR="$(cd "$(dirname "$SOURCE")" && pwd)"

log() {
  printf '[devc] %s\n' "$1"
}

die() {
  printf '[devc] %s\n' "$1" >&2
  exit 1
}

require_devcontainer() {
  command -v devcontainer >/dev/null 2>&1 || \
    die "devcontainer CLI not found. Install with: npm install -g @devcontainers/cli"
}

cmd_self_install() {
  local install_dir="$HOME/.local/bin"
  mkdir -p "$install_dir"
  ln -sf "$SCRIPT_DIR/install.sh" "$install_dir/devc"
  log "Installed devc at $install_dir/devc"
}

cmd_template() {
  local target="${1:-.}"
  mkdir -p "$target/.devcontainer"
  cp "$SCRIPT_DIR/Dockerfile" "$target/.devcontainer/Dockerfile"
  cp "$SCRIPT_DIR/devcontainer.json" "$target/.devcontainer/devcontainer.json"
  cp "$SCRIPT_DIR/post_install.py" "$target/.devcontainer/post_install.py"
  cp "$SCRIPT_DIR/.zshrc" "$target/.devcontainer/.zshrc"
  log "Template copied to $target/.devcontainer"
}

cmd_up() {
  require_devcontainer
  devcontainer up --workspace-folder "${1:-.}"
}

cmd_rebuild() {
  require_devcontainer
  devcontainer up --workspace-folder "${1:-.}" --remove-existing-container
}

cmd_shell() {
  require_devcontainer
  devcontainer exec --workspace-folder "${1:-.}" zsh
}

case "${1:-help}" in
  self-install)
    cmd_self_install
    ;;
  template)
    cmd_template "${2:-.}"
    ;;
  .)
    cmd_template "."
    cmd_up "."
    ;;
  up)
    cmd_up "${2:-.}"
    ;;
  rebuild)
    cmd_rebuild "${2:-.}"
    ;;
  shell)
    cmd_shell "${2:-.}"
    ;;
  *)
    cat <<'EOF'
Usage:
  devc .               Copy template and start container
  devc up              Start existing devcontainer
  devc rebuild         Rebuild existing devcontainer
  devc shell           Open zsh inside running devcontainer
  devc template [dir]  Copy template files into .devcontainer
  devc self-install    Install the helper into ~/.local/bin
EOF
    ;;
esac
