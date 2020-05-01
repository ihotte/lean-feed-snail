#
# Copyright (C) 2008-2014 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk
include $(TOPDIR)/feeds/snail/snail.mk
include $(TOPDIR)/feeds/snail/luci/luci.mk

PKG_NAME:=luci-base-snail

LUCI_TYPE:=mod
LUCI_BASENAME:=snail

LUCI_TITLE:=LuCI snail libraries
LUCI_DEPENDS:=+snail-files


include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
