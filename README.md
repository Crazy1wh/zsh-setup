# zsh setup

在新的 Ubuntu/Debian、Fedora/RHEL 或 Alpine 服务器上安装与本机一致的 zsh 配置：

```sh
curl -fsSL https://raw.githubusercontent.com/Crazy1wh/zsh-setup/main/install.sh | bash
```

脚本会安装 zsh，配置 Oh My Zsh、`git`、`zsh-autosuggestions` 和
`zsh-syntax-highlighting`，并在覆盖已有 `.zshrc` 前创建备份。

脚本不会安装、复制或引用 OpenClaw；NVM 仅在远端已经安装时加载。
