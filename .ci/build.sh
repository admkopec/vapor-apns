#!/usr/bin/env bash

VERSION="5.3"
echo "Swift $VERSION Continuous Integration";

# Determine OS
UNAME=`uname`;
if [[ $UNAME == "Darwin" ]];
then
    OS="macos";
else
    if [[ $UNAME == "Linux" ]];
    then
        UBUNTU_RELEASE=`lsb_release -a 2>/dev/null`;
        if [[ $UBUNTU_RELEASE == *"20.04"* ]];
        then
            OS="ubuntu2004";
        else
            OS="ubuntu1804";
        fi
    else
        echo "Unsupported Operating System: $UNAME";
    fi
fi
echo "🖥 Operating System: $OS";

if [[ $OS != "macos" ]];
then
    echo "📚 Installing Dependencies"
    sudo apt-get install -y clang libicu-dev uuid-dev

    echo "🐦 Installing Swift";
    if [[ $OS == "ubuntu2004" ]];
    then
        SWIFTFILE="swift-$VERSION-RELEASE-ubuntu20.04";
    else
        SWIFTFILE="swift-$VERSION-RELEASE-ubuntu18.04";
    fi
    wget https://swift.org/builds/swift-$VERSION-release/$OS/swift-$VERSION-RELEASE/$SWIFTFILE.tar.gz
    tar -zxf $SWIFTFILE.tar.gz
    export PATH=$PWD/$SWIFTFILE/usr/bin:"${PATH}"
else
    echo "📚 Installing Dependencies"
    brew tap vapor/homebrew-tap
    brew install ctls
fi

echo "📅 Version: `swift --version`";

echo "🚀 Building";
swift build
if [[ $? != 0 ]];
then
    echo "❌  Build failed";
    exit 1;
fi

echo "💼 Building Release";
swift build -c release
if [[ $? != 0 ]];
then
    echo "❌  Build for release failed";
    exit 1;
fi

echo "🔎 Testing";

swift test
if [[ $? != 0 ]];
then
    echo "❌ Tests failed";
    exit 1;
fi

echo "✅ Done"
