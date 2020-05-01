#!/bin/sh

[ -x /usr/bin/grep ] && \
{
	alias  grep='/usr/bin/grep --color=auto'
	alias egrep='/usr/bin/grep --color=auto -E'
	alias fgrep='/usr/bin/grep --color=auto -F'
}


alias nsg='netstat -nlp | grep -n'
alias psg='/bin/busybox ps | grep -n'

