# Makefile for SwiftBot

TARGET = Sources
OS = $(shell uname)

SWIFT_FILES = $(TARGET)/main.swift

PERFECT_ROOT = /app/.delta/usr/src/perfect/PerfectLib

DEBUG = -g -Onone -Xcc -DDEBUG=1
SWIFTC = swift
SWIFTC_FLAGS = -frontend -c $(DEBUG) -module-cache-path $(MODULE_CACHE_PATH) -emit-module \
                -I /app/.delta/usr/local/lib \
                -I /app/.delta/usr/include \
                -I /app/.delta/usr/include/x86_64-linux-gnu \
                -I $(PERFECT_ROOT)/linked/LibEvent \
                -I $(PERFECT_ROOT)/linked/OpenSSL_Linux \
                -I $(PERFECT_ROOT)/linked/ICU \
                -I $(PERFECT_ROOT)/linked/SQLite3 \
                -I $(PERFECT_ROOT)/linked/LinuxBridge \
                -I $(PERFECT_ROOT)/linked/cURL_Linux
MODULE_CACHE_PATH = /tmp/modulecache
Linux_SHLIB_PATH = $(shell dirname $(shell dirname $(shell which swiftc)))/lib/swift/linux
SHLIB_PATH = -L$($(OS)_SHLIB_PATH)

Perfect_FLAGS = $(SHLIB_PATH) -luuid -lswiftCore -lswiftGlibc /app/.delta/usr/local/lib/PerfectLib.so \
                -Xlinker -rpath -Xlinker $($(OS)_SHLIB_PATH) -shared
PostgreSQL_FLAGS = $(SHLIB_PATH) -luuid -lswiftCore -lswiftGlibc /app/.delta/usr/local/lib/PostgreSQL.so \
                -Xlinker -rpath -Xlinker $($(OS)_SHLIB_PATH) -shared

install:
        mv $(TARGET).so ../PerfectLibraries

modulecache:
        @mkdir -p $(MODULE_CACHE_PATH)

$(TARGET): modulecache
        @mkdir -p $(MODULE_CACHE_PATH)

$(TARGET): modulecache
        $(SWIFTC) $(SWIFTC_FLAGS) $(SWIFT_FILES) -o $@.o -module-name $@ -emit-module-path $@.swiftmodule
        clang++ $(Perfect_FLAGS) $@.o -o $@.so

clean:
        @rm *.o
