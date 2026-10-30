# 配置文件备份

本仓库备份日常使用的 Linux 配置文件，目录结构镜像 `~/.config`。

| 目录 | 原路径 | 内容 |
| --- | --- | --- |
| `ghostty/` | `~/.config/ghostty/` | Ghostty 终端配置（`config` 为主配置，`config.ghostty` 为备用副本） |
| `yazi/` | `~/.config/yazi/` | Yazi 文件管理器（`yazi.toml` 行为配置、`theme.toml` 主题、`init.lua` 启用 zoxide 自动记录） |
| `fish/` | `~/.config/fish/` | Fish shell（`config.fish`、`conf.d/`、`functions/`、`completions/`） |
| `tabby/` | `~/.config/tabby/` | Tabby 终端（仅 `config.yaml`） |

未包含：Tabby 的插件目录 `plugins/`（含 `node_modules`）与缓存目录、fish 的 `fish_variables`（机器运行时生成）。

## 恢复

```bash
cp -a ghostty/.  ~/.config/ghostty/
cp -a yazi/.     ~/.config/yazi/
cp -a fish/.     ~/.config/fish/
cp -a tabby/.    ~/.config/tabby/
```

## 备注

- Yazi 需先安装 `yazi`/`ya`（如放在 `~/.local/bin`），以及 `7zip`、`fd-find`、`ffmpeg`、`jq`、`poppler-utils`、`ripgrep`、`fzf` 等依赖；`yazi.toml` 中的打开方式已适配 Linux（`xdg-open`）。
- 终端字体 Maple Mono NF CN 需单独安装。
- fish 的 `y` 函数（`functions/y.fish`）封装 yazi，退出后自动 cd 到最后浏览的目录。
