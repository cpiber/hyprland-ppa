#!/bin/bash

set -xe
cd "$sourcefolder"
eval "`sed -n '/^[^ ]\+=/p' scripts/generateVersion.sh`"
vars="`sed -n 's/^\([^ ]\+\)=.*$/\1/p' scripts/generateVersion.sh`"
echo "$vars" |
  while IFS= read -r line; do
    sed -i "s/^$line=.*$/$line='${!line}'/" "$buildfolder/scripts/generateVersion.sh"
  done
