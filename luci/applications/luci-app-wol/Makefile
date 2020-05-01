#
# Copyright (C) 2016-2020 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(TOPDIR)/feeds/snail/snail.mk
include $(TOPDIR)/feeds/snail/luci/luci.mk


LUCI_TITLE:=LuCI Support for Wake-on-LAN
LUCI_DEPENDS:=+etherwake
LUCI_EXTRA_DEPENDS:=luci-base-snail


include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature

