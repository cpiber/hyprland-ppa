#!/bin/bash

set -xe
cd "$buildfolder"

sed -i 's/# G14 //' debian/rules
sed -i 's/g\(cc\|++\),/g\1-14,/g' debian/control
