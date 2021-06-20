#!/bin/sh

# Generate configure
./buildconf

# Clean up previous builds
make clean
rm -rf iOS/out

# TODO: Build for Catalyst & Simulator
PLATFORM=iPhoneOS # iPhoneSimulator # iPhoneOS
HOST=arm-apple-darwin
ARCH=arm64

XCODE_ROOT=`xcode-select -print-path`
PLATFORM_PATH=$XCODE_ROOT/Platforms/$PLATFORM.platform/Developer
SDK_PATH=$PLATFORM_PATH/SDKs/$PLATFORM.sdk
echo $SDK_PATH
FLAGS="-isysroot $SDK_PATH -arch $ARCH -miphoneos-version-min=14.5"
PLATFORM_BIN_PATH=$XCODE_ROOT/Toolchains/XcodeDefault.xctoolchain/usr/bin
CFLAGS="$FLAGS -std=gnu99"
CXXFLAGS="$FLAGS -std=gnu++11 -stdlib=libc++"
LDFLAGS="$FLAGS -lresolv -dynamiclib -framework ios_system -F$PWD/ios_system.xcframework/ios-arm64"

export CFLAGS CXXFLAGS LDFLAGS

CONFIGURE_FLAGS="--host=$HOST --enable-embed=shared --enable-cli --disable-phpdbg --disable-phar --enable-static --without-pear --disable-opcache --disable-opcache-jit --without-iconv --disable-cgi --disable-shared --enable-mysqlnd --with-pdo-mysql --with-mysqli --without-pcre-jit"
./configure $CONFIGURE_FLAGS
make

# Generate frameworks
cp sapi/cli/php iOS/php
cd iOS
mkdir out
mkdir out/php.framework
mv php out/php.framework/php
cp Info.plist out/php.framework/Info.plist
cd out
xcodebuild -create-xcframework -framework php.framework -output php.xcframework