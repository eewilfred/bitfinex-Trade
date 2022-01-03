#!/bin/bash

set -eo pipefail
cd bitfinex-Trade/bitfinex-Trade/

xcodebuild -workspace bitfinex-Trade.xcworkspace \
            -scheme bitfinex-Trade\ iOS \
            -destination platform=iOS\ Simulator,OS=13.3,name=iPhone\ 11 \
            clean test
