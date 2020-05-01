#!/bin/bash

# TERM=xterm

case "$TERM" in
    xterm*)
        export TERM=xterm-256color
        ;;
    screen*)
        export TERM=screen-256color
        ;;
esac


(x=`tput op` y=`printf %76s`; for i in {0..256}; do
    o=00$i; echo -e ${o:${#o}-3:3} `tput setaf $i; tput setab $i`${y// /=}$x;
done)



