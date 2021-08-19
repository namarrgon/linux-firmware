# This file implements the GNOME Build API:
# http://people.gnome.org/~walters/docs/build-api.txt

FIRMWAREDIR = /lib/firmware
#OPTIONS = ""


ifeq ($(PRUNE),yes)
	OPTIONS += "--prune"
endif

ifeq ($(COMPRESS),yes)
	OPTIONS += "--compress"
endif

ifeq ($(VERBOSE),yes)
	OPTIONS += "--verbose"
endif

all:

check:
	@./check_whence.py

install:
	mkdir -p $(DESTDIR)$(FIRMWAREDIR)
	./copy-firmware.sh $(OPTIONS) $(DESTDIR)$(FIRMWAREDIR)
