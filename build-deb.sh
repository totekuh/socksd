#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <version> [binary-file]"
    exit 1
fi

binary_file="$2"
if [ -z "$binary_file" ]; then
    binary_file="socksd"
fi

rm -rf socksd
make

version="$1"
deb_package_name="$binary_file"_"$version"
deb_package_path="./deb/$deb_package_name"

rm -rf "$deb_package_path"

mkdir -p "$deb_package_path/DEBIAN"
cp "./deb/DEBIAN/control" "$deb_package_path/DEBIAN/control"
echo "Version: $(echo "$version"|sed 's/v//g')" >> "$deb_package_path/DEBIAN/control"
echo "Architecture: $(dpkg --print-architecture)" >> "$deb_package_path/DEBIAN/control"

cp "./deb/DEBIAN/preinst" "$deb_package_path/DEBIAN/preinst"

mkdir -p "./$deb_package_path/usr/bin"
cp "$binary_file" "$deb_package_path/usr/bin/"

cd "./deb"
dpkg-deb --build "$deb_package_name"
cd ..
