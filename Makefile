ARCHS ?= arm64 arm64e
TARGET ?= iphone:clang:latest:14.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

SHARED_DIR = $(CURDIR)/../AndromedaProject/Shared

TWEAK_NAME = TinderAndromeda
TinderAndromeda_FILES = AppSpecific/DetectionHooks.x \
    $(SHARED_DIR)/Core/Bootstrap.x \
    $(SHARED_DIR)/Core/ContainerManager.m \
    $(SHARED_DIR)/Core/ContainerContext.m \
    $(SHARED_DIR)/Ghost/GhostProfile.m \
    $(SHARED_DIR)/Ghost/GhostHooks.x \
    $(SHARED_DIR)/GPS/GPSManager.m \
    $(SHARED_DIR)/GPS/GPSHooks.x \
    $(SHARED_DIR)/Container/FileRedirector.x \
    $(SHARED_DIR)/Container/KeychainProxy.m \
    $(SHARED_DIR)/Container/DefaultsProxy.x \
    $(SHARED_DIR)/UI/ShadowWindow.m \
    $(SHARED_DIR)/UI/FloatingButton.m \
    $(SHARED_DIR)/UI/ContainerSheet.m \
    $(SHARED_DIR)/UI/GhostPanel.m \
    $(SHARED_DIR)/UI/GPSMapView.m \
    $(SHARED_DIR)/Utils/IDGenerator.m
TinderAndromeda_CFLAGS = -I$(SHARED_DIR)/Core -I$(SHARED_DIR)/Ghost -I$(SHARED_DIR)/GPS -I$(SHARED_DIR)/Container -I$(SHARED_DIR)/UI -I$(SHARED_DIR)/Utils -I$(CURDIR)/../AndromedaProject -I$(CURDIR)/AppSpecific -fobjc-arc -Wno-unguarded-availability -Wno-deprecated-declarations
TinderAndromeda_FRAMEWORKS = UIKit CoreLocation MapKit Security CoreTelephony
TinderAndromeda_LIBRARIES = substrate
TinderAndromeda_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

include $(THEOS_MAKE_PATH)/tweak.mk
