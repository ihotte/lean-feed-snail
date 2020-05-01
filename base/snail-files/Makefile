#
# Copyright (C) 2006-2020 OpenWrt.org
# Copyright (C) 2016-2020 Snail
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(TOPDIR)/feeds/snail/snail.mk

PKG_NAME:=snail-files
PKG_VERSION:=$(shell TZ='Asia/Shanghai' date +3.%-m.%-d)
PKG_RELEASE:=$(shell TZ='Asia/Shanghai' date +%X | sed 's/://g')

PKG_FLAGS:=essential
PKG_BUILD_DEPENDS:=lua/host

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=base
  CATEGORY:=Snail
  SUBMENU:=Base system
  TITLE:=Base filesystem for Snail OpenWrt
  DEPENDS:=
endef

define Package/$(PKG_NAME)/description
  Base filesystem for Snail OpenWrt.
endef


define Package/$(PKG_NAME)/conffiles
/etc/default/motd
endef

define Build/Prepare
	:;
endef

define Build/Configure
	:;
endef

define Build/Compile
	:;
endef


define Package/$(PKG_NAME)/install
	$(CP) files/* $(1)/
	if [ -d "arch/$(ARCH)" ]; then \
		$(CP) arch/$(ARCH)/* $(1)/ 2>/dev/null || true; \
	else true; fi

	$(SED) 's/@PKG_VERSION@/$(PKG_VERSION)/g' $(1)/etc/uci-defaults/snail-files.sh

	(cd "$(1)" && find . -type d -exec chmod 0755 {} \;) || true;
	(cd "$(1)" && find . -type f -exec chmod 0644 {} \;) || true;

	if [ -d "$(1)/bin" ]; then chmod 0755 -R "$(1)/bin"; else true; fi
	if [ -d "$(1)/sbin" ]; then chmod 0755 -R "$(1)/sbin"; else true; fi
	if [ -d "$(1)/usr/bin" ]; then chmod 0755 -R "$(1)/usr/bin"; else true; fi
	if [ -d "$(1)/usr/sbin" ]; then chmod 0755 -R "$(1)/usr/sbin"; else true; fi
	if [ -d "$(1)/etc/uci-defaults" ]; then chmod 0755 -R "$(1)/etc/uci-defaults"; else true; fi
endef


$(eval $(call BuildPackage,$(PKG_NAME)))

