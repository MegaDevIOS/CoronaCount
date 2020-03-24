include $(THEOS)/makefiles/common.mk


ARCHS = arm64 arm64e

TARGET = iphone:clang:13.2:13.2

BUNDLE_NAME = coronapref
coronapref_FILES = CoronaRootListController.m HBAppearanceSettings.m
coronapref_INSTALL_PATH = /Library/PreferenceBundles
coronapref_FRAMEWORKS = UIKit

coronapref_PRIVATE_FRAMEWORKS = Preferences
coronapref_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/coronapref.plist$(ECHO_END)
