#!/bin/sh

PKG_NAME=cloudreve

uci -q batch <<-EOF >/dev/null
	delete firewall.${PKG_NAME}
	set firewall.${PKG_NAME}=include
	set firewall.${PKG_NAME}.reload=1
	set firewall.${PKG_NAME}.type=script
	set firewall.${PKG_NAME}.path=/etc/firewall.d/${PKG_NAME}.sh
	commit firewall
EOF

exit 0

