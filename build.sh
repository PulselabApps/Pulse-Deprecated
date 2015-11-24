# Clean repository, DerivedData folder and simulator
git reset --hard
git clean -fd
rm -rf ~/Library/Developer/Xcode/DerivedData/PulseiOS*
xcrun simctl erase all
# Unit tests
xctool \
-scheme PulseiOS \
-workspace PulseiOS/PulseiOS.xcworkspace \
-destination "platform=iOS Simulator,name=iPhone 6,OS=9.1" \
-sdk iphonesimulator \
-reporter junit:test-results/TEST-UnitTests.xml \
-reporter pretty \
clean test
