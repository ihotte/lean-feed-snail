#!/bin/sh

. /etc/openwrt_release
. /lib/functions/snail.sh

SCRIPT_NAME=${0##*/}


enable()
{
	display_alert "" && display_alert "Enable luci debug"
	display_alert ""

	uci revert luci; uci set luci.ccache.enable=0; uci commit luci;
	display_alert "Disable cache" "modulecache" "ext"

	sed -i 's/^luci.dispatcher.indexcache/-- luci.dispatcher.indexcache/' /www/cgi-bin/luci
	display_alert "Disable cache" "indexcache" "ext"

	clean >/dev/null
	display_alert ""
	display_alert "Clean cache files" "indexcache && modulecache" "ext"
	display_alert ""
}

disable()
{
	display_alert "" && display_alert "Disable luci debug"
	display_alert ""

	uci revert luci; uci set luci.ccache.enable=1; uci commit luci;
	display_alert "Enable luci cache" "modulecache" "ext"

	sed -i 's/^-- luci.dispatcher.indexcache/luci.dispatcher.indexcache/' /www/cgi-bin/luci
	display_alert "Enable luci cache" "indexcache" "ext"

	clean >/dev/null
	display_alert ""
	display_alert "Clean cache files" "indexcache && modulecache" "ext"
	display_alert ""
}


clean()
{
	display_alert "" && display_alert "Clean luci cache files"
	display_alert ""

	rm -rf /tmp/luci-indexcache
	display_alert "Clean cache files" "indexcache" "ext"

	rm -rf /tmp/luci-modulecache
	display_alert "Clean cache files" "modulecache" "ext"

	display_alert ""
}


usage() {
	[ -n "$@" ] && echo $@
	echo "Usage: ${SCRIPT_NAME} [-c|--clean] [-e|--enable] [-d|--disable] [-h|--help]"
	exit 1
}

ACTION=clean

while getopts cdehq opt; do
	case $opt in
		c) ACTION=clean ;;
		e) ACTION=enable ;;
		d) ACTION=disable ;;

		q) QUIET=yes ;;
		h) usage "" ;;

		\?) usage "Unknown parameter specified" ;;
	esac
done

case "$ACTION" in
	clean) clean ;;
	enable) enable ;;
	disable) disable ;;

	*) usage "" ;;
esac

exit 0

