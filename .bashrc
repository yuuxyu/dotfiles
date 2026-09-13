# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

alias vim='nvim'
alias zed='zeditor'
alias open='(setsid xdg-open . >/dev/null 2>&1 &)'

# Fuzzy-jump to a ghq-managed repo with fzf
pg() {
	local repo
	repo=$(ghq list -p | fzf --height 40% --reverse --prompt="repo> ") || return
	cd "$repo" || return
}

# dotfiles (bare git repo)
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
