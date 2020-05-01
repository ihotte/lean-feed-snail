#!/bin/sh

# alias  ol='opkg list'
# alias oli='opkg list-installed'
alias  ol='opkg list --force-isatty |grep -n "-"'
alias oli='opkg list-installed |grep -n "-"'


# alias olu='opkg list-upgradable |sort'
# alias olc='opkg list-changed-conffiles |sort'
alias olu='opkg list-upgradable |sort |grep -n "-"'
alias olc='opkg list-changed-conffiles |sort |grep -n .'

alias  oi='opkg install'
alias ori='opkg install --force-reinstall'
alias ofi='opkg install --force-reinstall --force-depends'

alias  or='opkg remove'
alias oar='opkg remove --autoremove'
alias ofr='opkg remove --force-depends'

alias   ou='opkg update'
alias  olg='opkg list --force-isatty |grep -n'
alias olcg='opkg list |cut -f1-3 -d" " |grep -n'

