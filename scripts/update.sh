#!/bin/sh

if [ $# -lt 1 ]; then
  echo "Usage: $0 {project}"
  exit 1
fi

set -xe
reporoot="`cd "$(dirname "$0")/.." && pwd`"

project="$1"
sourcefolder="$reporoot/$project/source"
cd "$sourcefolder"
curhead="`git rev-parse HEAD`"
# for now only standard pull, no tags
git pull --quiet --rebase
git submodule update --init --recursive
newhead="`git rev-parse HEAD`"
shorthead="`git rev-parse --short HEAD`"
if [ "$curhead" = "$newhead" ]; then
  echo "Already up-to-date"
  exit 0
fi
changes="`git log --pretty="%h %s" $curhead..$newhead`"
cd ..
curver="`dpkg-parsechangelog --show-field Version | sed 's/+git.*//'`"
dist="`dpkg-parsechangelog --show-field Distribution`"
newver="$curver+git`date "+%Y%m%d%H%M"`-$shorthead"
dch -v "$newver" -D "$dist" "Update to main $shorthead"
echo "$changes" |
  while IFS= read -r line; do
    dch -a "$line"
  done
