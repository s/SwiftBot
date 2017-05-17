# Makefile for SwiftBot

# Few shortcuts for swift package manager

test:
	xcodebuild -project SwiftBot.xcodeproj -scheme SwiftBot build test

generate:
	swift package generate-xcodeproj

build:
	swift build
