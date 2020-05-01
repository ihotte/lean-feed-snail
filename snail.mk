#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#


EMPTY:=
COMMA:=,
SPACE:= $(EMPTY) $(EMPTY)


UPX:=upx
TOUCH:=touch
CHMOD?=chmod


GIT_REVISION?=$(shell git log -1 --format="%ct")


# LOCAL_MIRROR:=http://mirrors.miwifi.io:6080/sources




# PATCH_DIR?=./patches
# FILES_DIR?=./files

# RSTRIP:=:
# STRIP:=:


