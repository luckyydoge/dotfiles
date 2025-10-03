# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/z/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

alias ls='eza'
alias ll='ls -lh'
alias lla='ls -alh'
alias lg='lazygit'
alias vim='nvim'
alias nv='nvim'

alias cd='z'

eval "$(starship init zsh)"

export KEYTIMEOUT=5
export EDITOR=nvim

export http_proxy="http://127.0.0.1:10801"
export https_proxy="$http_proxy"
export all_proxy="socks5://127.0.0.1:10800"
export HTTP_PROXY="http://127.0.0.1:10801"
export HTTPS_PROXY="$http_proxy"
export ALL_PROXY="socks5://127.0.0.1:10800"
export no_proxy="localhost,127.0.0.1,docker.internal,192.168.49.2"
# export http_proxy=""
# export https_proxy=""
# export all_proxy=""
# export HTTP_PROXY=""
# export HTTPS_PROXY=""
# export ALL_PROXY=""
#

source ./.fzf.zsh

# export DISPLAY=:12
export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
export DISPLAY=:0
export XCURSOR_SIZE=48

export PATH="$HOME/.scripts:$PATH"
export PATH="$HOME/stow/qemu-10.1.0/build/:$PATH"
export PATH="$HOME/stow/qemu-10.1.0/build/riscv64-softmmu:$PATH"
export PATH="$HOME/stow/qemu-10.1.0/build/riscv64-linux-user:$PATH"

eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
