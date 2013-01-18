#!/bin/sh

#
# MASTAdView SDK Deployment Package Build Script
# Copyright (c) 2012 Mocean Mobile. All rights reserved.
#
# This script is a helper to build the zip package for hosting on the project site.
# It is not required for customers using the SDK in their own products.
#

rm build.zip

xcodebuild -project Sources/MASTAdView/MASTAdView.xcodeproj -scheme MASTAdView clean build OBJROOT=buildtmp || exit 1
xcodebuild -project Sources/MASTAdView/MASTAdView.xcodeproj -scheme Framework clean build OBJROOT=buildtmp || exit 1
xcodebuild -project Sources/MASTAdView/MASTAdView.xcodeproj -scheme Appledoc clean build OBJROOT=buildtmp || exit 1

xcodebuild -project Samples/Samples/Samples.xcodeproj -scheme Samples clean build OBJROOT=buildtmp || exit 1
xcodebuild -project Samples/InstallationDirect/InstallationDirect.xcodeproj -scheme InstallationDirect clean build OBJROOT=buildtmp || exit 1
xcodebuild -project Samples/InstallationFramework/InstallationFramework.xcodeproj -scheme InstallationFramework clean build OBJROOT=buildtmp || exit 1

rm -rf `find . -name xcuserdata -type d`
rm -rf `find . -name buildtmp -type d`
rm -rf `find . -name .DS_Store` 

zip -rX build.zip Documentation Samples Sources ThirdParty

