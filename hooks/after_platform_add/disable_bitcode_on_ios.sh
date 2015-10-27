#!/bin/sh

# Exit, if there's no ios here.
[[ $CORDOVA_PLATFORMS == *"ios"* ]] || exit 0

# This is needed until https://github.com/danwilson/google-analytics-plugin/issues/148 gets fixed.
if ! cat "platforms/ios/cordova/build.xcconfig" | grep -q "ENABLE_BITCODE"; then
  echo "
ENABLE_BITCODE = NO" >> platforms/ios/cordova/build.xcconfig
fi
