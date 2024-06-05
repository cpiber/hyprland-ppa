#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 {project}"
  exit 1
fi

set -xe
reporoot="`cd "$(dirname "$0")/.." && pwd`"

project="$1"
sourcefolder="$reporoot/$project/source"
debianfolder="$reporoot/$project/debian"
buildfolder="/tmp/hyprland-ppa/$project"
mkdir -p /tmp/hyprland-ppa/
rm -rf "$buildfolder"
[ -d "$sourcefolder" ] && cp -ra "$sourcefolder" "$buildfolder" || mkdir "$buildfolder"
cp -ra "$debianfolder" "$buildfolder"
[ -f "$reporoot/$project/prepare.sh" ] && . "$reporoot/$project/prepare.sh" || :
