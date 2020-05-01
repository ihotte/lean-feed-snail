#!/bin/sh

. /etc/openwrt_release
. /lib/functions/snail.sh

SCRIPT_NAME=${0##*/}



updateIndex() {
	display_alert "" && \
	display_alert "Update index from the remote repository";
	if [ -n "${QUIET}" ]; then
		opkg --verbosity=0 update
	else
		display_alert ""; opkg update; display_alert "";
	fi
	display_alert "Update index from the remote repository" "done" "ext";
}


#
# Generate distfeeds
#
generate_distfeeds() {
	local MIRRORS="$1"

	local core kmod
	[ -f /usr/share/snail/repositories/core/Packages.gz ] && core="local"
	[ -f /usr/share/snail/repositories/kmod/Packages.gz ] && kmod="local"

	cat <<-EOT > /etc/opkg/distfeeds.conf
		${core:+#}src/gz openwrt_core ${MIRRORS}/releases/${DISTRIB_RELEASE}/targets/${DISTRIB_TARGET}/packages
		src/gz openwrt_main ${MIRRORS}/releases/${DISTRIB_RELEASE}/packages/${DISTRIB_ARCH}/packages
		src/gz openwrt_base ${MIRRORS}/releases/${DISTRIB_RELEASE}/packages/${DISTRIB_ARCH}/base
		src/gz openwrt_luci ${MIRRORS}/releases/${DISTRIB_RELEASE}/packages/${DISTRIB_ARCH}/luci
	EOT

	rm -f /etc/opkg/openwrt_core.conf
	[ -n "$core" ] && cat <<-EOT > /etc/opkg/openwrt_core.conf
		## This is the local package repository, do not remove!
		src/gz openwrt_local_core file:///usr/share/snail/repositories/core
	EOT

	rm -f /etc/opkg/openwrt_kmod.conf
	[ -n "$kmod" ] && cat <<-EOT > /etc/opkg/openwrt_kmod.conf
		## This is the local package repository, do not remove!
		src/gz openwrt_local_kmod file:///usr/share/snail/repositories/kmod
	EOT

	rm -rf /var/opkg-lists
	rm -rf /var/opkg/lists
}


#
# OpenWrt 官方源
# https://downloads.openwrt.org
#
openwrt() {
	local MIRRORS="https://downloads.openwrt.org"
	display_alert "" && display_alert "Switch repository to" "${MIRRORS}" "ext";
	generate_distfeeds "$MIRRORS"
	updateIndex
}


#
# 腾讯云软件源
# https://mirrors.cloud.tencent.com/lede
#
tencent() {
	local MIRRORS="https://mirrors.cloud.tencent.com/lede"
	display_alert "" && display_alert "Switch repository to" "${MIRRORS}" "ext";
	generate_distfeeds "$MIRRORS"
	updateIndex
}


#
# 中国科学技术大学开源软件镜像
# https://ipv4.mirrors.ustc.edu.cn/lede
#
ustc() {
	local MIRRORS="https://ipv4.mirrors.ustc.edu.cn/lede"
	display_alert "" && display_alert "Switch repository to" "${MIRRORS}" "ext";
	generate_distfeeds "$MIRRORS"
	updateIndex
}


#
# 清华大学开源软件镜像站
# https://mirrors4.tuna.tsinghua.edu.cn/lede
#
tsinghua() {
	local MIRRORS="https://mirrors4.tuna.tsinghua.edu.cn/lede"
	display_alert "" && display_alert "Switch repository to" "${MIRRORS}" "ext";
	generate_distfeeds "$MIRRORS"
	updateIndex
}



usage() {
	[ -n "$@" ] && echo $@
	echo "Usage: ${SCRIPT_NAME} [-o|--openwrt] [-t|--tencent] [-u|--ustc] [-a|--tsinghua] [-q|--quiet] [-h|--help]"
	exit 1
}


while getopts otuahq opt; do
	case $opt in
		o) ACTION=openwrt ;;
		t) ACTION=tencent ;;

		u) ACTION=ustc ;;
		a) ACTION=tsinghua ;;

		q) QUIET=yes ;;
		h) usage "" ;;

		\?) usage "Unknown parameter specified" ;;
	esac
done

case "$ACTION" in
	openwrt) openwrt ;;
	tencent) tencent ;;

	ustc) ustc ;;
	tsinghua) tsinghua ;;

	*) usage "" ;;
esac

exit 0

