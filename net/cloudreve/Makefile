#
# Copyright (C) 2006-2020 OpenWrt.org
# Copyright (C) 2016-2020 Snail
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(TOPDIR)/feeds/snail/snail.mk

PKG_NAME:=cloudreve
PKG_VERSION:=3.0.0
PKG_RELEASE:=2


ifeq ($(ARCH), x86_64)
PKG_SOURCE:=cloudreve_$(PKG_VERSION)_linux_amd64.tar.gz
PKG_MD5SUM:=e388ee0071df59e480011d14f4227400
endif
ifeq ($(ARCH), aarch64)
PKG_SOURCE:=cloudreve_$(PKG_VERSION)_linux_arm64.tar.gz
PKG_MD5SUM:=44ee650dd2872dd1d941a4cdf04cb8df
endif


PKG_HOMEPAGE:=https://github.com/cloudreve/Cloudreve
PKG_RELEASES:=https://github.com/cloudreve/Cloudreve/releases

include $(INCLUDE_DIR)/package.mk

RSTRIP:=:
STRIP:=:

define Package/$(PKG_NAME)
    SECTION:=net
    CATEGORY:=Snail
    SUBMENU:=Network - NAS
    TITLE:=A project helps you build your own cloud in minutes
    DEPENDS:=@(aarch64||x86_64) +snail-files
    USERID:=$(PKG_NAME):$(PKG_NAME)
    URL:=$(PKG_HOMEPAGE)
endef


define Package/$(PKG_NAME)/conffiles
/etc/config/$(PKG_NAME)
endef


define Package/$(PKG_NAME)/postrm
#!/bin/sh

# firewall
uci -q batch <<-EOT
	delete firewall.$(PKG_NAME)
	commit firewall
EOT

# delete temp files
rm -f /var/run/$(PKG_NAME).pid
rm -f /var/log/$(PKG_NAME).log
rm -rf /var/log/$(PKG_NAME)

exit 0
endef


define Build/Prepare
	tar -xzf ./dist/$(PKG_SOURCE) -C $(PKG_BUILD_DIR)
endef

define Build/Configure
	:;
endef

define Build/Compile
	$(UPX) $(PKG_BUILD_DIR)/$(PKG_NAME)
endef


define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_CONF) ./files/$(PKG_NAME).uci $(1)/etc/config/$(PKG_NAME)
	$(INSTALL_BIN) ./files/$(PKG_NAME).init $(1)/etc/init.d/$(PKG_NAME)

	$(INSTALL_DIR) $(1)/etc/firewall.d
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/firewall.sh $(1)/etc/firewall.d/$(PKG_NAME).sh
	$(INSTALL_BIN) ./files/uci-defaults.sh $(1)/etc/uci-defaults/50-$(PKG_NAME).sh

	$(INSTALL_DIR) $(1)/app/$(PKG_NAME)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME) $(1)/app/$(PKG_NAME)/$(PKG_NAME)
	$(INSTALL_BIN) ./files/$(PKG_NAME).sh $(1)/app/$(PKG_NAME)/
endef


# Package/$(PKG_NAME)/subdir=snail/net

$(eval $(call BuildPackage,$(PKG_NAME)))

