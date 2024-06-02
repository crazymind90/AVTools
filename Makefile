ARCHS = arm64e arm64

 

THEOS_PACKAGE_SCHEME=rootless

export SDKVERSION = 14.5

export iP = 192.168.1.102
export Port = 22
export Pass = alpine
export Bundle = com.apple.springboard

DEBUG = 0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AVTools

AVTools_FILES = Tweak.xm
AVTools_CFLAGS = -fobjc-arc
AVTools_PRIVATE_FRAMEWORKS = SpringBoardServices
AVTools_CODESIGN_FLAGS = -Sent.plist

include $(THEOS_MAKE_PATH)/tweak.mk


before-package::
		$(ECHO_NOTHING) chmod 755 $(CURDIR)/.theos/_/DEBIAN/*  $(ECHO_END)
		$(ECHO_NOTHING) chmod 755 $(CURDIR)/.theos/_/DEBIAN  $(ECHO_END)


install6::
		install6.exec
