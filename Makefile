ARCHS = arm64
TARGET = iphone:clang:16.5:14.0

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = FBFix
FBFix_FILES = FBFix.m
FBFix_FRAMEWORKS = Foundation UIKit Security

include $(THEOS_MAKE_PATH)/library.mk
