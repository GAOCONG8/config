if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Apple Silicon（M1/M2）路径
if test -d /opt/homebrew
    set -gx HOMEBREW_PREFIX /opt/homebrew
    set -gx PATH /opt/homebrew/bin $PATH
# Intel Mac 路径
else if test -d /usr/local/Homebrew
    set -gx HOMEBREW_PREFIX /usr/local
    set -gx PATH /usr/local/bin $PATH
end

# 别名配置（Fish 用 alias 或 abbr，推荐 abbr 更轻量）
### cmake
abbr -a cb 'cmake -B build'
abbr -a bb 'cmake --build build'
### fd
abbr fd 'fd --color=always --no-ignore'
abbr fdf 'fd --type f --color=always --no-ignore'
abbr fdd 'fd --type d --color=always --no-ignore'
abbr vi vim

# 代理
## 代理配置
set -g PROXY_HOST "127.0.0.1"
set -g PROXY_PORT "7890"
set -g PROXY_URL "http://$PROXY_HOST:$PROXY_PORT"

## 代理设置快捷命令
abbr -a proxy 'set -gx http_proxy $PROXY_URL; set -gx https_proxy $PROXY_URL; set -gx all_proxy $PROXY_URL; echo "Proxy set (HTTP/HTTPS/ALL) to $PROXY_URL"'
abbr -a noproxy 'set -e http_proxy; set -e https_proxy; set -e all_proxy; echo "Proxy cleared"'
abbr -a testproxy 'curl -I https://www.google.com'

## 针对开发场景的代理设置
abbr -a gitproxy "git config --global http.proxy $PROXY_URL"
abbr -a gitnoproxy 'git config --global --unset http.proxy'

## Python pip 镜像（如需要）
abbr -a pipcn 'pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple'
abbr -a pipdefault 'pip config unset global.index-url'

## 系统代理（针对需要系统级代理的应用）
abbr -a sysproxy "export http_proxy=$PROXY_URL; export https_proxy=$PROXY_URL"

# Other
abbr py python3
abbr pyactive 'source ~/.py-venv/bin/activate.fish'
abbr git-web 'open (git remote get-url origin | sed "s|git@\(.*\):\(.*\).git|https://\1/\2|")'


# Created by `pipx` on 2026-06-21 06:46:11
set PATH $PATH /home/gc/.local/bin
set -gx PATH ~/.npm-global/bin $PATH


set -gx PATH "/home/gc/.local/bin" $PATH
alias lss 'exa --git --time-style long-iso'
alias lst 'exa --git --tree --level=2'


# Flatpak 桌面集成路径（修复 fish 下 XDG_DATA_DIRS 警告）
if test -n "$XDG_DATA_DIRS"
    set -x XDG_DATA_DIRS /var/lib/flatpak/exports/share $HOME/.local/share/flatpak/exports/share $XDG_DATA_DIRS
else
    set -x XDG_DATA_DIRS /var/lib/flatpak/exports/share $HOME/.local/share/flatpak/exports/share /usr/local/share /usr/share
end

# QODER_DISPATCHER_PATH v1
fish_add_path -p -m $HOME/.qoder/entry
# END QODER_DISPATCHER_PATH v1
