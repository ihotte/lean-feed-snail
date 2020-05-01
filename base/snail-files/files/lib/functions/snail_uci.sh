#!/bin/sh
# Copyright (C) 2006-2019 OpenWrt.org
#
# /etc/init.d/shadowsocks
#


#
# validate_uci_section <package> <type> <name>
#
validate_uci_section()
{
	local _package="$1"
	local _type="$2"
	local _name="$3"
	local _result
	local _error
	shift; shift; shift
	_result=`/sbin/validate_data "$_package" "$_type" "$_name" "$@" 2> /dev/null`
	_error=$?
	eval "$_result"
	[ "$_error" = "0" ] || `/sbin/validate_data "$_package" "$_type" "$_name" "$@" 1> /dev/null`
	return $_error
}


#
# uci_get_by_name <section> <option>
#
uci_get_by_name() {
    local ret=$(uci -q get $PKG_NAME.$1.$2 2>/dev/null)
    echo ${ret:=$3}
}

#
# uci_get_by_type <section-type> <option>
#
uci_get_by_type() {
    local ret=$(uci -q get $PKG_NAME.@$1[0].$2 2>/dev/null)
    echo ${ret:=$3}
}

#
# uci_get_by_index <section-type> <option> <index>
#
uci_get_by_index() {
    local index=${3:-0}
    local ret=$(uci -q get $PKG_NAME.@$1[$index].$2 2>/dev/null)
    echo ${ret:=$4}
}


#
# uci_bool_by_name <section> <option>
#
uci_bool_by_name() {
    case "$(uci_get_by_name $1 $2)" in
        1|on|true|yes|enabled) return 0;;
    esac
    return 1
}


