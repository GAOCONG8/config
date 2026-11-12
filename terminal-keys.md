# 终端通用快捷键

跨终端应用统一使用的一套键位约定：同一动作在不同应用（Ghostty、Herdr 等）里使用同样的按键。本文件是键位约定的来源，各应用的具体配置见对应章节。

> 约定的是「动作 → 按键」；应用自身的扩展功能（空间、Agent、布局等）不属于通用集，单独列在该应用章节。

## 一、通用键位约定

### 标签页

| 动作 | 按键 |
| --- | --- |
| 上一个标签 | `Alt+←` |
| 下一个标签 | `Alt+→` |
| 新建标签 | `Ctrl+Shift+T` |
| 关闭标签 | `Ctrl+Shift+W` |
| 重命名标签 | `F2` |

### 分屏 / 窗格

| 动作 | 按键 |
| --- | --- |
| 向右分屏 | `Ctrl+V` |
| 向下分屏 | `Ctrl+-` |
| 关闭当前分屏 | `Ctrl+W` |
| 向左 / 下 / 上 / 右移动焦点 | `Alt+H` / `Alt+J` / `Alt+K` / `Alt+L` |
| 缩放 / 还原当前分屏 | `Alt+Z` |
| 交换窗格位置（可选） | `Alt+Shift+H/J/K/L` |

### 字号与滚动

| 动作 | 按键 |
| --- | --- |
| 增大字号 | `Ctrl+Shift++` |
| 减小字号 | `Ctrl+Shift+-` |
| 重置字号 | `Ctrl+Shift+0` |
| 滚动到历史顶部 | `Ctrl+↑` |
| 滚动到历史底部 | `Ctrl+↓` |

### 复制与粘贴

| 动作 | 按键 |
| --- | --- |
| 复制 | `Ctrl+Shift+C` / `Ctrl+Insert` |
| 粘贴 | `Ctrl+Shift+V` / `Shift+Insert` |
| 终端内搜索 | `Ctrl+Shift+F` |
| 按词左移 / 右移（发送 `Alt+B` / `Alt+F`） | `Ctrl+←` / `Ctrl+→` |

## 二、占用说明

以下按键会被应用层拦截，不再传给内部程序：

- `Ctrl+V`：会失去 vim 的 visual block 及程序的 `^V`。
- `Ctrl+W`：会失去 shell / 程序的删除前一个词（`^W`）。
- 如需恢复，可将对应绑定删除或将动作改为「交给程序」（Herdr 中值为 `"terminal"`）。

## 三、Ghostty 落地配置

来源：`~/code/config/ghostty/config`

```ini
keybind = alt+left=previous_tab
keybind = alt+right=next_tab

keybind = ctrl+v=new_split:right
keybind = ctrl+minus=new_split:down
keybind = ctrl+w=close_surface

keybind = alt+h=goto_split:left
keybind = alt+l=goto_split:right
keybind = alt+k=goto_split:top
keybind = alt+j=goto_split:bottom

keybind = alt+z=toggle_split_zoom

keybind = ctrl+shift+plus=increase_font_size:1
keybind = ctrl+shift+minus=decrease_font_size:1
keybind = ctrl+shift+zero=reset_font_size

keybind = ctrl+arrow_up=scroll_to_top
keybind = ctrl+arrow_down=scroll_to_bottom
```

Ghostty 中未纳入通用集的个人配置：`alt+e`（等分分屏）、`global:cmd+t`（快速终端）、`ctrl+shift+comma`（重载配置）。

## 四、Herdr 落地配置

来源：`~/code/config/herdr-app/keys.json`
生效位置：`~/.config/herdr-app/keys.json` → 软链接到本仓库
原始默认备份：`~/.config/herdr-app/keys.json.bak-20261112-183115`

### 通用动作对应

| 动作 | 按键 | Herdr 命令 |
| --- | --- | --- |
| 上一个 / 下一个标签 | `Alt+←` / `Alt+→` | `tab.prev` / `tab.next` |
| 新建标签 | `Ctrl+Shift+T` | `tab.new` |
| 关闭标签 | `Ctrl+Shift+W` | `tab.close` |
| 重命名标签 | `F2` | `tab.rename` |
| 向右分屏 | `Ctrl+V` / `Ctrl+Shift+O` | `pane.split:right` |
| 向下分屏 | `Ctrl+-` / `Ctrl+Shift+E` | `pane.split:down` |
| 关闭窗格 | `Ctrl+W` / `Ctrl+Shift+X` | `pane.close` |
| 移动焦点 | `Alt+H/J/K/L` | `pane.go:left/down/up/right` |
| 交换窗格 | `Alt+Shift+H/J/K/L` | `pane.swap:left/down/up/right` |
| 缩放窗格 | `Alt+Z` / `Ctrl+Shift+Z` | `pane.zoom` |
| 放大 / 缩小 / 重置 | `Ctrl+Shift++` / `Ctrl+Shift+-` / `Ctrl+Shift+0` | `app.zoom_in` / `app.zoom_out` / `app.zoom_reset` |
| 滚动到顶 / 底 | `Ctrl+↑` / `Ctrl+↓` | `terminal.scroll`（`to: top/bottom`） |
| 复制 / 粘贴 | `Ctrl+Shift+C` / `Ctrl+Shift+V` | `terminal.copy` / `terminal.paste` |
| 终端内搜索 | `Ctrl+Shift+F` | `terminal.search` |

### Herdr 专有扩展（不属于通用集）

| 动作 | 按键 | 命令 |
| --- | --- | --- |
| 切换空间 | `Alt+1` … `Alt+9` | `space.select:N` |
| 新建 / 重命名空间 | `Ctrl+Shift+N` / `Shift+F2` | `space.new` / `space.rename` |
| 上一个 / 下一个空间 | `Ctrl+Shift+PageUp/PageDown` | `space.prev` / `space.next` |
| 上一个 / 下一个标签 | `Ctrl+PageUp/PageDown`、`Alt+[` / `Alt+]` | `tab.prev` / `tab.next` |
| 切换标签 | `Ctrl+1` … `Ctrl+9` | `tab.select:N` |
| 上一个 / 下一个 Agent | `Alt+↑` / `Alt+↓` | `agent.prev` / `agent.next` |
| 切换布局 | `Ctrl+Shift+L` | `layout.switch` |
| 显示 / 隐藏侧栏 | `Ctrl+Shift+B` | `layout.toggle:sidebar` |
| 命令面板 / picker | `Ctrl+Shift+P` / `Ctrl+Shift+K` | `app.palette` / `mod.open:picker` |
| 设置 / 帮助 | `Ctrl+,` / `Ctrl+?` | `app.settings` / `app.help` |
| 重置缩放 | `Ctrl+0` | `app.zoom_reset` |

### 修改方法

编辑 `~/code/config/herdr-app/keys.json`，保存后约一秒内实时生效：

```json
{
  "global":   { "ctrl-shift-t": "tab.new", "ctrl-v": "pane.split:right" },
  "layout:terminals": { "ctrl-shift-pagedown": "space.next" },
  "terminal": { "ctrl-shift-c": "terminal.copy", "ctrl-1": "terminal" },
  "mod:editor": { "ctrl-s": "editor.save" }
}
```

- **分区优先级**：`terminal` > `layout:<布局名>` > `global`；`mod:<名字>` 用于面板自己的按键。
- **值的四种写法**：命令名（`"tab.new"`）、带首参数简写（`"pane.split:right"`）、对象（`{"command": "layout.resize", "args": {"id": "sidebar", "px": 240}}`）、交还程序（`"terminal"`）。
- **修饰键**：`ctrl-`、`shift-`、`alt-`、`cmd-`（macOS）。
- **删除条目**即取消绑定。
- **改错时**：保留上一份可用配置，原因写入 `~/.config/herdr-app/keys.json.error`。
- **兜底**：`Ctrl+Alt+Shift+Esc` 永远有效，可重置布局与键位。
- 查看命令与状态：`herdr-app commands`、`herdr-app status`；完整说明见 `~/.config/herdr-app/AGENTS.md`。
