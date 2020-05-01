#!/bin/sh
#
# Copyright (C) 2006-2019 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# Cloudreve integration for firewall
#
. /lib/functions.sh
. /lib/functions/snail.sh

PKG_NAME=cloudreve
PKG_DESC=Cloudreve


fflush()
{
	iptables-save | grep -q "!fw3: ${PKG_DESC}" && _logger "Flushing all filewall rule";
	iptables-save | grep "!fw3: ${PKG_DESC}" | while read line; do
		echo "iptables ${line}" | sed 's/-A/-D/' | /bin/ash;
	done
}

fconfig()
{
	local cfg="$1"
	local enabled
	config_get_bool enabled "$cfg" 'enabled' 0
	[ $enabled -eq 1 ] || return 1;

	local internet port
	config_get_bool internet "$cfg" 'internet' 0
	config_get port "$cfg" 'port' 8052

	if [ $internet -eq 1 -a -n "${port}" ]; then
		_logger "Configure filewall rule for section => ${cfg}.wan" >/dev/null
		iptables -A input_wan_rule -p tcp -m tcp --dport $port -m comment --comment "!fw3: ${PKG_DESC}" -j ACCEPT
	fi
}


fflush
config_load $PKG_NAME
config_foreach fconfig $PKG_NAME
exit 0

