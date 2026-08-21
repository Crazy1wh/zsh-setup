# zsh setup

在 Linux 或 macOS 上快速安装一套实用的 zsh 配置：

```sh
curl -fsSL https://raw.githubusercontent.com/Crazy1wh/zsh-setup/main/install.sh | bash
```

脚本支持以下系统：

- macOS（需要 [Homebrew](https://brew.sh/)）
- Ubuntu/Debian
- Fedora/RHEL
- Alpine Linux

脚本会安装 zsh 和 Git，配置 Oh My Zsh、`git`、`zsh-autosuggestions`
以及 `zsh-syntax-highlighting`，并在覆盖已有 `.zshrc` 前自动创建备份。

如果系统中已经安装 NVM，生成的配置会自动加载它；脚本不会安装 NVM。

安装完成后重新打开终端即可生效，也可以执行：

```sh
exec zsh
```
