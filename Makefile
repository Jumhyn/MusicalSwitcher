include theos/makefiles/common.mk

musicalswitcher_FRAMEWORKS = Foundation CoreFoundation UIKit AudioToolbox
ARCHS = arm64 armv7
TARGET=iphone:latest:7.0
TWEAK_NAME = musicalswitcher
musicalswitcher_FILES = MusicalSwitcher.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
