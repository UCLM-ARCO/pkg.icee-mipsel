# -*- mode: makefile-gmake; coding: utf-8 -*-

include $(TOPDIR)/rules.mk

PKG_NAME    := icee
PKG_REV     := 1.3
PKG_VERSION := $(PKG_REV)
PKG_RELEASE := 1.3

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

PKG_SRC     := IceE-1.3.0-linux.tar.gz
PKG_SRC_DIR := src
PKG_SRC_URL := http://zeroc.com/download/IceE/1.3/$(PKG_SRC)

include $(INCLUDE_DIR)/package.mk

define Package/icee/Default
  URL        := http://www.zeroc.com/icee/index.html
  MAINTAINER := Oscar Acena <oscar.acena@gmail.com>
endef

define Package/icee
	SECTION  := net
	CATEGORY := Network
	TITLE    := ZeroC Ice for Embedded Devices
endef

define Package/icee/description
        Ice-E ("Embedded Ice") is a compact communications engine designed
        specifically for use in environments where resources are scarce,
        such as Internet-enabled smart phones, personal digital assistants
        (PDAs), and embedded controllers.
endef

define Build/Prepare
	[ ! -d $(PKG_SRC_DIR) ] || rm -rf $(PKG_SRC_DIR)
	wget $(PKG_SRC_URL) -O $(PKG_SRC)
	mkdir -p $(PKG_SRC_DIR)
	tar zxvf $(PKG_SRC) --strip-components 1 -C $(PKG_SRC_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(MAKE) -C $(PKG_SRC_DIR) configure all
endef

define Package/icee/install
	$(INSTALL_DATA) ./libIceE.1.2.so $(1)/lib
endef

define Package/icee/postinst
endef


$(eval $(call BuildPackage,icee))
