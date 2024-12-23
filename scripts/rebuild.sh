#!/bin/sh

if [ $# -lt 1 ]; then
  echo "Usage: $0 {project}"
  exit 1
fi

set -xe
reporoot="`cd "$(dirname "$0")/.." && pwd`"
project="$1"
shift
debfolder="$reporoot/$project/debian"
dist="`dpkg-parsechangelog -l "$debfolder/changelog" --show-field Distribution`"
dch -c "$debfolder/changelog" -i -U -D "$dist" "Rebuild for dependencies"
