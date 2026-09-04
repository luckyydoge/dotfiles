# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/z/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# 插件由 NixOS 系统级 programs.zsh (/etc/zshrc) 提供
source <(carapace zsh)

eval "$(atuin init zsh)"

alias ls='eza'
# 替代传统 ll，带标题、图标和 Git 状态
alias ll='eza -l --icons --header --git'

# 替代传统 la，显示隐藏文件
alias la='eza -la --icons --header --git'

# 查看三层深度的项目树
alias lt='eza --tree --level 3 --icons'

# 仅显示目录并按时间排序
alias lsd='eza -D --sort=modified'

alias cd='z'

alias e='emacsclient -t'

alias opencode='LD_LIBRARY_PATH="/run/current-system/sw/share/nix-ld/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" opencode'
alias oc='LD_LIBRARY_PATH="/run/current-system/sw/share/nix-ld/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" opencode'

eval "$(starship init zsh)"
source $HOME/dotfiles/zsh/.fzf.zsh
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
eval "$(fnm env --use-on-cd --shell zsh)"
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# foot 自动进入 zellij；ZELLIJ 变量防止 pane 内嵌套，detach 后落在裸 zsh
if [[ -o interactive && -z "$ZELLIJ" ]]; then
  zellij attach --create main
fi

export EDITOR="emacsclient -t"

# alias ll='ls -lh'
# alias lla='ls -alh'
# alias lg='lazygit'
# alias vim='nvim'
# alias nv='nvim'


# export KEYTIMEOUT=5
# export EDITOR=nvim

# export http_proxy="http://127.0.0.1:10808"
# export https_proxy="$http_proxy"
# export all_proxy="socks5h://127.0.0.1:10808"
# export HTTP_PROXY="http://127.0.0.1:10808"
# export HTTPS_PROXY="$http_proxy"
# export ALL_PROXY="socks5h://127.0.0.1:10808"
# export no_proxy="localhost,127.0.0.1,docker.internal,192.168.49.2"
# export http_proxy=""
# export https_proxy=""
# export all_proxy=""
# export HTTP_PROXY=""
# export HTTPS_PROXY=""
# export ALL_PROXY=""
#


# export DISPLAY=:12
# export XMODIFIERS=@im=fcitx
# export QT_IM_MODULE=fcitx
# export GTK_IM_MODULE=fcitx
# export DISPLAY=:0
# export XCURSOR_SIZE=48

# export PATH="$HOME/.scripts:$PATH"

