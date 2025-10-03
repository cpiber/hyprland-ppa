#!/bin/sh

set -xe

: NOTE: Assumes that 'apt-cache' knows the package!
: NOTE: Arguments are apt package names, not the folders as with other scripts!

reporoot="`cd "$(dirname "$0")/.." && pwd`"
apt-cache rdepends "$@" | sed '/^[^ ]/d;s/^\s\+\(lib\)\?\|-dev$\|[0-9]\+$//g' | sort | uniq | while read -r package; do
  if [ "$package" = "hyprland" ]; then
    package="hyprland-stable"
  elif [ "$package" = "hyprland-unstable" ]; then
    package="hyprland"
  fi
  if [ -d "$reporoot/$package" ]; then
    "$reporoot/scripts/rebuild.sh" "$package"
  fi
done
