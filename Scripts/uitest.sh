#!/bin/bash

EXECUTE_NAME="MemoryGraphDemo"
SCHEME="MemoryGraphDemoUITests"
ROOT_PATH="../"
TRIGER_CMD="trigerLLDBExportMemoryGraphFile"
OUT_PUT="./"

/usr/bin/expect ./emg.sh $EXECUTE_NAME $TRIGER_CMD $OUT_PUT &

cd $ROOT_PATH
xcodebuild test -workspace $EXECUTE_NAME.xcworkspace -scheme $SCHEME -destination platform="iOS Simulator",name="iPhone 14"

