#!/bin/sh

[ -x /usr/bin/git ] && \
{
	alias gb='git branch'
	alias gc='git checkout'
	alias gd='git diff'
	alias gs='git status'

	alias gl='git log --oneline --all --graph --decorate --max-count=30'
	alias gll='git log --oneline --all --graph --decorate'

	alias ga='git add'
	alias gm='git commit -m R`date +%Y-%m-%dT%H%M%S`'

	alias gf='git fetch'
	alias gp='git push'
}

