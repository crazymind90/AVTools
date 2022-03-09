ARCHS = arm64e arm64

export SDKVERSION = 10.3
export TARGET = iphone:clang:14.4:14.4

# export SDKVERSION = 13.0
# sudo iproxy 2001 22

export iP = localhost
export Port = 2001
export Pass = alpine
export Bundle = com.apple.springboard

DEBUG = 0

# THEOS_DEVICE_IP = 192.168.100.4

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AVTools

AVTools_FILES = Tweak.xm
AVTools_CFLAGS = -fobjc-arc
AVTools_LIBRARIES = rocketbootstrap
AVTools_PRIVATE_FRAMEWORKS = AppSupport SpringBoardServices

include $(THEOS_MAKE_PATH)/tweak.mk


install5::
		install5.exec
