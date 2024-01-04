#! /bin/sh

echo "Downloading ios_system..."
sh ./downloadFrameworks.sh
echo "Compiling PHP and creating frameworks"
sh ./build.sh