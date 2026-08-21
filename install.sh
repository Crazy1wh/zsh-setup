#!/usr/bin/env bash
set -Eeuo pipefail

# Installs the shared zsh setup. OpenClaw is intentionally not included.

OMZ_DIR="${ZSH:-$HOME/.oh-my-zsh}"
CUSTOM_DIR="$OMZ_DIR/custom"
ZSHRC="$HOME/.zshrc"
OMZ_REPO="https://github.com/ohmyzsh/ohmyzsh.git"
AUTOSUGGESTIONS_REPO="https://github.com/zsh-users/zsh-autosuggestions.git"
SYNTAX_HIGHLIGHTING_REPO="https://github.com/zsh-users/zsh-syntax-highlighting.git"

as_root() {
  if [[ "$(id -u)" -eq 0 ]]; then
    "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    printf '需要 root 权限安装系统包，请使用 root 运行或安装 sudo。\n' >&2
    exit 1
  fi
}

install_packages() {
  if command -v apt-get >/dev/null 2>&1; then
    as_root apt-get update
    as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y zsh git ca-certificates
  elif command -v dnf >/dev/null 2>&1; then
    as_root dnf install -y zsh git ca-certificates
  elif command -v yum >/dev/null 2>&1; then
    as_root yum install -y zsh git ca-certificates
  elif command -v apk >/dev/null 2>&1; then
    as_root apk add --no-cache zsh git ca-certificates
  else
    printf '未找到支持的包管理器（apt-get/dnf/yum/apk）。\n' >&2
    exit 1
  fi
}

clone_if_missing() {
  local repo="$1" target="$2"
  if [[ ! -d "$target/.git" ]]; then
    mkdir -p "$(dirname "$target")"
    git clone --depth=1 "$repo" "$target"
  fi
}

backup_zshrc() {
  if [[ -f "$ZSHRC" ]] && ! grep -q '^# Managed by zsh-setup/install.sh$' "$ZSHRC"; then
    cp -a "$ZSHRC" "$ZSHRC.before-zsh-setup.$(date +%Y%m%d%H%M%S)"
  fi
}

write_zshrc() {
  backup_zshrc
  umask 022
  cat >"$ZSHRC" <<'ZSHRC'
# Managed by zsh-setup/install.sh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source "$ZSH/oh-my-zsh.sh"

# Load NVM when it is already installed; this script does not install NVM.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
ZSHRC
}

main() {
  install_packages
  clone_if_missing "$OMZ_REPO" "$OMZ_DIR"
  clone_if_missing "$AUTOSUGGESTIONS_REPO" "$CUSTOM_DIR/plugins/zsh-autosuggestions"
  clone_if_missing "$SYNTAX_HIGHLIGHTING_REPO" "$CUSTOM_DIR/plugins/zsh-syntax-highlighting"
  write_zshrc
  rm -f "$HOME"/.zcompdump "$HOME"/.zcompdump-*
  if command -v chsh >/dev/null 2>&1; then
    chsh -s "$(command -v zsh)" "$(id -un)" 2>/dev/null || true
  fi
  "$(command -v zsh)" -fc 'source ~/.zshrc; (( $+functions[compinit] )); (( $+functions[_zsh_autosuggest_start] )); [[ -n "$ZSH_HIGHLIGHT_VERSION" ]]'
  printf 'zsh 配置完成：%s\n' "$ZSHRC"
}

main "$@"
