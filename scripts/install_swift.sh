#!/bin/sh

# install dependencies
sudo apt-get install clang libicu-dev -y

pwd=`pwd`

# download and extract swift
wget https://swift.org/builds/swift-4.1.2-release/ubuntu1404/swift-4.1.2-RELEASE/swift-4.1.2-RELEASE-ubuntu14.04.tar.gz
mkdir $pwd/swift
tar -xvzf swift-4.1.2-RELEASE-ubuntu14.04.tar.gz -C ~/swift

# make swift available
export PATH=$pwd/swift/swift-4.1.2-RELEASE-ubuntu14.04/usr/bin:"${PATH}"

pwd
echo $PATH
ls -l $pwd/swift/swift-4.1.2-RELEASE-ubuntu14.04/usr/bin

# print swift version
swift -–version