TARGET =: clang
ARCHS = armv7 arm64

TWEAK_NAME = MusicalSwitcher
MusicalSwitcher_FILES = MusicalSwitcher.xm
MusicalSwitcher_FRAMEWORKS = Foundation CoreFoundation UIKit AudioToolbox

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

internal-after-install::
	install.exec "killall -9 backboardd"