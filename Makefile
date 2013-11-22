# -*- mode: makefile-gmake; coding: utf-8 -*-

include $(TOPDIR)/rules.mk

PKG_NAME    := icee
PKG_REV     := 1.3
PKG_VERSION := $(PKG_REV)
PKG_RELEASE := 0

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

PKG_SRC     := IceE-1.3.0-linux.tar.gz
PKG_SRC_DIR := src
PKG_SRC_URL := http://zeroc.com/download/IceE/1.3/$(PKG_SRC)

include $(INCLUDE_DIR)/package.mk

define Package/icee/Default
        URL        := http://www.zeroc.com/icee/index.html
        MAINTAINER := Oscar Acena <oscar.acena@gmail.com>
endef

define Package/icee/description
        Ice-E ("Embedded Ice") is a compact communications engine designed
        specifically for use in environments where resources are scarce,
        such as Internet-enabled smart phones, personal digital assistants
        (PDAs), and embedded controllers.
endef

define Package/icee-server
	$(call Package/dropbear/Default)
	SECTION    := libs
	CATEGORY   := Libraries
	TITLE      := ZeroC Ice for Embedded Devices (server version)
	DEPENDS    := +libpthread +uclibcxx
endef

define Package/icee-client
	$(call Package/dropbear/Default)
	SECTION    := libs
	CATEGORY   := Libraries
	TITLE      := ZeroC Ice for Embedded Devices (client version)
	DEPENDS    := +libpthread +uclibcxx
endef

define Build/Prepare
	[ ! -d $(PKG_SRC_DIR) ] || rm -rf $(PKG_SRC_DIR)
	[ -f $(PKG_SRC) ] || wget $(PKG_SRC_URL) -O $(PKG_SRC)
	mkdir -p $(PKG_SRC_DIR)
	tar zxvf $(PKG_SRC) --strip-components 1 -C $(PKG_SRC_DIR)
	patch -d $(PKG_SRC_DIR) -p1 < openwrt.patch
endef

define Build/Configure
	$(MAKE) -C $(PKG_SRC_DIR) configure \
	    HAS_ROUTER=no \
	    HAS_LOCATOR=no \
	    HAS_BATCH=no \
	    HAS_WSTRING=no \
	    HAS_OPAQUE_ENDPOINTS=yes \
	    HAS_AMI=no
endef

define Build/Compile
	$(MAKE) -C $(PKG_SRC_DIR) \
	    CXX=$(TARGET_CXX) \
	    LDPLATFORMFLAGS="-nodefaultlibs -lgcc -lc -luClibc++"
endef

define Package/icee-server/install
	$(INSTALL_DIR) $(1)/lib
	$(CP) -d $(PKG_SRC_DIR)/cppe/lib/libIceE.so* $(1)/lib/
endef

define Package/icee-client/install
	$(INSTALL_DIR) $(1)/lib
	$(CP) -d $(PKG_SRC_DIR)/cppe/lib/libIceEC.so* $(1)/lib/
endef


$(eval $(call BuildPackage,icee-client))
$(eval $(call BuildPackage,icee-server))

