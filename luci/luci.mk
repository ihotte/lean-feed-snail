

LUCI_NAME?=$(notdir ${CURDIR})
LUCI_TYPE?=$(word 2,$(subst -, ,$(LUCI_NAME)))
LUCI_BASENAME?=$(patsubst luci-$(LUCI_TYPE)-%,%,$(LUCI_NAME))
# LUCI_PKGARCH?=$(if $(realpath src/Makefile),,all)


LUCI_CATEGORY?=Snail LuCI
LUCI_MAKE_LUAC?=1


LUCI_DEPENDS?=
LUCI_EXTRA_DEPENDS?=


PKG_NAME?=$(LUCI_NAME)
PKG_HOMEPAGE?=
PKG_RELEASES?=

# PKG_SUBDIR?=snail/luci

# PKG_FLAGS?=

# ifeq ($(LUCI_TYPE),theme)
  # PKG_SUBDIR:=snail/themes
# endif

