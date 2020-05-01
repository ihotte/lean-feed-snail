#!/bin/sh

export PATH='/root/.bin:/usr/sbin:/usr/bin:/sbin:/bin'

export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.png=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:';

case "$TERM" in
	xterm)
		export TERM=xterm-256color
		;;
	screen)
		export TERM=screen-256color
		;;
esac


#
# Linux 终端显示 Git 当前所在分支
#
git_branch() {
	local branch="`git branch 2>/dev/null | grep "^\*" | sed -e "s/^\*\ //"`"
	if [ "${branch}" != "" ];then
		if [ "${branch}" = "(no branch)" ]; then
			branch="(`git rev-parse --short HEAD`...)"
		fi
		echo " ($branch)"
	fi
}


if [ "$USER" = "root" ]; then
	export PS1='\u@\h:\[\033[1;31m\]\w\[\033[1;32m\]$(git_branch)\[\033[0m\] \$ '
else
	export PS1='\u@\h:\[\033[1;36m\]\w\[\033[1;32m\]$(git_branch)\[\033[0m\] \$ '
fi

export PS1='\[\e[32m\][\[\e[m\]\[\e[31m\]\u\[\e[m\]\[\e[33m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]:\[\e[36m\]\w\[\e[m\]\[\e[32m\]]\[\e[m\]\[\e[32m\]\[\e[1;32m\]$(git_branch)\[\e[0m\] \$\[\e[m\] '


#
# fixup rlimit for samba4
#
# ulimit -HSn 65536
# ulimit -HSn 16384



