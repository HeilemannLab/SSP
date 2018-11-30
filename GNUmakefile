GNUSTEP_MAKEFILES = /usr/share/GNUstep/Makefiles
CC = gcc

include $(GNUSTEP_MAKEFILES)/common.make


TOOL_NAME = ssp.tool
$(TOOL_NAME)_OBJCFLAGS = -std=c99
$(TOOL_NAME)_HEADERS = SMBActions.h
$(TOOL_NAME)_HEADERS += SMBMolecule.h
$(TOOL_NAME)_HEADERS += SMBFileNames.h
$(TOOL_NAME)_HEADERS += SMBHistogram.h
$(TOOL_NAME)_HEADERS += SMBFlock.h
$(TOOL_NAME)_HEADERS += SMBParser.h
$(TOOL_NAME)_OBJC_FILES = main.m
$(TOOL_NAME)_OBJC_FILES += SMBActions.m
$(TOOL_NAME)_OBJC_FILES += SMBMolecule.m
$(TOOL_NAME)_OBJC_FILES += SMBFileNames.m
$(TOOL_NAME)_OBJC_FILES += SMBHistogram.m
$(TOOL_NAME)_OBJC_FILES += SMBFlock.m
$(TOOL_NAME)_OBJC_FILES += SMBParser.m
#$(TOOL_NAME)_RESOURCE_FILES =

include $(GNUSTEP_MAKEFILES)/tool.make


