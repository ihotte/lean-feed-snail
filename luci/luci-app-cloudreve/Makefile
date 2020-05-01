#
# Copyright (C) 2016-2020 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(TOPDIR)/feeds/snail/snail.mk
include $(TOPDIR)/feeds/snail/luci/luci.mk


LUCI_TITLE:=LuCI Support for Cloudreve
LUCI_DEPENDS:=+cloudreve
LUCI_EXTRA_DEPENDS:=luci-base-snail


define Package/$(PKG_NAME)/postrm
#!/bin/sh

# ucitrack
uci -q batch <<-EOT
	delete ucitrack.@$(LUCI_BASENAME)[-1]
	commit ucitrack
EOT

exit 0
endef


include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature

