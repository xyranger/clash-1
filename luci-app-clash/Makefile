# Copyright (C) 2016 Openwrt.org
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for clash
LUCI_DEPENDS:=+clash +pdnsd-alt +kmod-tcp-bbr +coreutils-nohup
LUCI_PKGARCH:=all
PKG_NAME:=luci-app-clash
PKG_VERSION:=0.16.0

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
