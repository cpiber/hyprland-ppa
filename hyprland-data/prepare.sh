#!/bin/bash

set -xe
cd "$sourcefolder"

: Copy install assets from hyprland submodule, fallback to hyprland-stable
[ -d "$buildfolder/assets" ] || mkdir -p "$buildfolder/assets"
if [ -d ../../hyprland/source/assets/install/ ]; then
  cp -ra ../../hyprland/source/assets/install/*.png "$buildfolder/assets"
elif [ -d ../../hyprland-stable/source/assets/install/ ]; then
  cp -ra ../../hyprland-stable/source/assets/install/*.png "$buildfolder/assets"
else
  echo "No assets source: ../../hyprland/source/assets/install/, ../../hyprland-stable/source/assets/install/" >&2
  exit 1
fi
