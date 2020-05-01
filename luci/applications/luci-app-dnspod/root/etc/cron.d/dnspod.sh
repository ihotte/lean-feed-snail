#!/bin/sh
#
# Copyright (C) 2006-2019 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

PKG_NAME=dnspod

logger -p warn -t "cron.d" "reloading ${PKG_NAME}"

if [ -x /etc/init.d/$PKG_NAME ]; then
	/etc/init.d/$PKG_NAME reload >/dev/null 2>&1
fi

if [ $? -eq 0 ]; then
	logger -p warn -t "cron.d" "${PKG_NAME} ok"
else
	logger -p warn -t "cron.d" "${PKG_NAME} failed"
fi

exit 0

