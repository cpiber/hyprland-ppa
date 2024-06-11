#!/bin/sh

if [ $# -lt 1 ]; then
  echo "Usage: $0 {project}"
  exit 1
fi

set -xe
reporoot="`cd "$(dirname "$0")/.." && pwd`"

project="$1"
sourcefolder="$reporoot/$project/source"
case "$project" in
  hyprland)
    type="main"
    ;;
  *)
    type="tag"
    ;;
esac

cd "$sourcefolder"
curhead="`git rev-parse HEAD`"
if [ "$type" = "main" ]; then
  git checkout main
  git pull --quiet --rebase
elif [ "$type" = "tag" ]; then
  git fetch --tags
  tag="`git describe --tags origin/main | sed 's/-[0-9]\+-g[0-9a-fA-F]\+//'`"
  git checkout "$tag"
  tag="`echo "$tag" | sed 's/^v//'`"
else
  echo "Invalid type $type"
  exit 1
fi
git submodule update --init --recursive
newhead="`git rev-parse HEAD`"
shorthead="`git rev-parse --short HEAD`"
if [ "$curhead" = "$newhead" ]; then
  echo "Already up-to-date"
  exit 0
fi
changes="`git log --pretty="%h %s" $curhead..$newhead`"
cd ..
dist="`dpkg-parsechangelog --show-field Distribution`"
if [ "$type" = "main" ]; then
  curver="`dpkg-parsechangelog --show-field Version | sed 's/+git.*//'`"
  newver="$curver+git`date "+%Y%m%d%H%M"`-$shorthead"
  dch -v "$newver" -D "$dist" "Update to main $shorthead"
else
  newver="$tag-1ppa1"
  dch -v "$newver" -D "$dist" "Update to release $tag"
fi
echo "$changes" |
  while IFS= read -r line; do
    dch -a "$line"
  done
