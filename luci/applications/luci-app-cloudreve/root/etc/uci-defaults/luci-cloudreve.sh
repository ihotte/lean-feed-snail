#!/bin/sh

PKG_NAME=cloudreve

uci -q batch <<-EOF >/dev/null
	delete ucitrack.@${PKG_NAME}[-1]
	add ucitrack ${PKG_NAME}
	set ucitrack.@${PKG_NAME}[-1].init=${PKG_NAME}
	commit ucitrack
EOF

exit 0

