#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 {project} [dist]"
  exit 1
fi

set -xe
reporoot="`cd "$(dirname "$0")/.." && pwd`"

project="$1"
shift
sourcefolder="$reporoot/$project/source"
debianfolder="$reporoot/$project/debian"
buildfolder="/tmp/hyprland-ppa/$project"
mkdir -p /tmp/hyprland-ppa/
rm -rf "$buildfolder"
[ -d "$sourcefolder" ] && cp -ra "$sourcefolder" "$buildfolder" || mkdir "$buildfolder"
cp -ra "$debianfolder" "$buildfolder"
if [ $# -gt 0 ]; then
  dch -c "$buildfolder/debian/changelog" -l "~1$1" -D "$1" "Rebuild for $1"
  if [ "$1" = "trixie" ]; then
    : Debian does not need this patch
    rm -r "$buildfolder/debian/patches/01-patch-cms" || :
    sed -i '/^01-patch-cms$/d' "$buildfolder/debian/patches/series" || :
  fi
fi
[ -f "$reporoot/$project/prepare.sh" ] && . "$reporoot/$project/prepare.sh" || :
