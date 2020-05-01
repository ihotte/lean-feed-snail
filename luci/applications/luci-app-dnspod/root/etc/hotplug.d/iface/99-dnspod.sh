#!/bin/sh
#
# Copyright (C) 2006-2019 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# DNSPod integration for hotplug.d
#
. /lib/functions.sh
. /lib/functions/snail.sh

PKG_NAME=dnspod
PKG_DESC=DNSPod


if [ "$ACTION" = "ifup" -a "$INTERFACE" = "wan" ]; then
	logger -p warn -t "hotplug.d" "reloading ${PKG_NAME}"

	if [ -x /etc/init.d/$PKG_NAME ]; then
		sleep 30 && /etc/init.d/$PKG_NAME reload >/dev/null 2>&1
	fi

	if [ $? -eq 0 ]; then
		_logger "reloading ${PKG_NAME} succeed"
	else
		_logger "reloading ${PKG_NAME} failed" "warn"
	fi
fi

exit 0

