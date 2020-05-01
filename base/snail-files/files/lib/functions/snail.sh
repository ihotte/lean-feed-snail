#!/bin/sh
# Copyright (C) 2006-2019 OpenWrt.org

OVERLAY_ROOT=

_logger()
{
	local from=[init.d]
	if (echo "$0" | grep -q 'cron.d'); then
		from="[cron.d]"
	elif (echo "$0" | grep -q 'firewall.d'); then
		from="[firewall.d]"
	elif (echo "$0" | grep -q 'hotplug.d'); then
		from="[hotplug.d]"
	fi

	/usr/bin/logger -p daemon.${2:-info} -t "${PKG_NAME:-unknown}${from}" "${1:-message}"
	echo "${PKG_NAME:-unknown}: $1"
}


_logger_user()
{
	/usr/bin/logger -p user.${2:-info} -t "${PKG_NAME:-unknown}" "${1:-message}"
	echo "${PKG_NAME:-unknown}: $1"
}


#
#--------------------------------------------------------------------------------------------------------------------------------
# Let's have unique way of displaying alerts
#--------------------------------------------------------------------------------------------------------------------------------
# display_alert <message> <highlight> <err|wrn|ext|info|*>
#
display_alert()
{
	local tmp=""
	[[ -n "${2}" ]] && tmp="[\e[0;33m $2 \x1B[0m]"

	case "${3}" in
		err)
		echo -e "[\e[0;31m error \x1B[0m] $1 $tmp"
		;;

		wrn)
		echo -e "[\e[0;35m warn \x1B[0m] $1 $tmp"
		;;

		ext)
		echo -e "[\e[0;32m o.k. \x1B[0m] \e[1;32m$1\x1B[0m $tmp"
		;;

		info)
		echo -e "[\e[0;32m o.k. \x1B[0m] $1 $tmp"
		;;

		*)
		echo -e "[\e[0;32m .... \x1B[0m] $1 $tmp"
		;;
	esac
}

# exit_with_error <message> <highlight>
#
# a way to terminate build process
# with verbose error message
#
exit_with_error()
{
	local _description=$1
	local _highlight=$2
	display_alert "$_description" "$_highlight" "err"
	display_alert "Process terminated" "" "info"
	exit 255
}


