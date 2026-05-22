ARCHS = arm64
TARGET = iphone:clang:16.5:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FBFix
FBFix_FILES = Tweak.xm
FBFix_FILTER_BUNDLES = com.facebook.Facebook

include $(THEOS_MAKE_PATH)/tweak.mk

