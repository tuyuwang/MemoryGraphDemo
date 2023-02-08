#!/bin/bash

EXECUTE_NAME="MemoryGraphDemo"
ROOT_PATH="../"
TRIGER_CMD=""trigerLLDBExportMemoryGraphFile""
OUT_PUT="./"

/usr/bin/expect ./emg.sh $EXECUTE_NAME $TRIGGER_CMD $OUT_PUT &

cd $ROOT_PATH
xcodebuild test -project $EXECUTE_NAME.xcodeproj -scheme $EXECUTE_NAME -destination platform="iOS Simulator",name="iPhone 14"

