#!/bin/bash

set -xe
cd "$buildfolder"

sed -i 's/# G14 //' debian/rules
sed -i 's/g\(cc\|++\),/g\1-14,/g' debian/control
echo "noble-02-revert-set-buffer-size" >> debian/patches/series
echo "noble-03-embed" >> debian/patches/series
echo "noble-04-gcc-port" >> debian/patches/series
