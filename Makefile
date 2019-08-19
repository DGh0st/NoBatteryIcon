export ARCHS = armv7 arm64
export TARGET = iphone:clang:8.1:8.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NoBatteryIcon
NoBatteryIcon_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
