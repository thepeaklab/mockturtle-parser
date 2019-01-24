#!/bin/sh

# install dependencies
sudo apt-get install clang libicu-dev -y

# download and extract swift
wget https://swift.org/builds/swift-4.1.2-release/ubuntu1404/swift-4.1.2-RELEASE/swift-4.1.2-RELEASE-ubuntu14.04.tar.gz
mkdir ~/swift
tar -xvzf swift-4.1.2-RELEASE-ubuntu14.04.tar.gz -C ~/swift

# make swift available
export PATH=~/swift/swift-4.1.2-RELEASE-ubuntu14.04/usr/bin:$PATH

# print swift version
swift –version