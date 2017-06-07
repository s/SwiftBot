# Makefile for SwiftBot
.DEFAULT_GOAL := build

# Few shortcuts for swift package manager

test:
	xcodebuild -project SwiftBot.xcodeproj -scheme SwiftBot build test

install:
	Scripts/install.py Sources/SwiftBot/config.swift

generate:
	swift package generate-xcodeproj

build:
	swift build

debug:
	if [ "$(brew services list mysql | grep '^mysql' | awk '{print $$2}')" == "started" ]; then brew services start mysql ; mysql -uroot <<<"CREATE DATABASE IF NOT EXISTS swiftbot" ; fi
	.build/debug/SwiftBot
