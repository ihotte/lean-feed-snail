#!/bin/sh

PKG_NAME=dnspod

uci -q batch <<-EOF >/dev/null
	delete ucitrack.@${PKG_NAME}[-1]
	add ucitrack ${PKG_NAME}
	set ucitrack.@${PKG_NAME}[-1].init=${PKG_NAME}
	commit ucitrack
EOF

if [ -x /etc/init.d/ucitrack ]; then
	ubus call service list '{"name": "ucitrack", "verbose": true}' 2>/dev/null | grep -q '"'${PKG_NAME}'"'
	[ $? -eq 0 ] || /etc/init.d/ucitrack reload >/dev/null
fi

exit 0

