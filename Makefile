INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = arm64 arm64e

VALID_ARCHS = arm64 arm64e


export THEOS_DEVICE_PORT=22
 export THEOS_DEVICE_IP=192.168.1.63





include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CoronaCount

CoronaCount_FILES = Tweak.xm
CoronaCount_CFLAGS = -fobjc-arc
CoronaCount_EXTRA_FRAMEWORKS +=  Cephei
SUBPROJECTS += coronapref
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
