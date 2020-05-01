#
# Copyright (C) 2016-2020 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(TOPDIR)/feeds/snail/snail.mk
include $(TOPDIR)/feeds/snail/luci/luci.mk


LUCI_TITLE:=LuCI Support for AliDDNS
LUCI_DEPENDS:=+curl +openssl-util
LUCI_EXTRA_DEPENDS:=luci-base-snail


define Package/$(PKG_NAME)/conffiles
/etc/config/$(LUCI_BASENAME)
endef


define Package/$(PKG_NAME)/postrm
#!/bin/sh

# ucitrack
uci -q batch <<-EOT
	delete ucitrack.@$(LUCI_BASENAME)[-1]
	commit ucitrack
EOT

# crontabs
rm -f /var/log/$(LUCI_BASENAME).log
if grep -qs "$(LUCI_BASENAME).sh" /etc/crontabs/root; then
	sed -i "/$(LUCI_BASENAME).sh/d" /etc/crontabs/root >/dev/null 2>&1
	crontab /etc/crontabs/root
fi

exit 0
endef


include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature

