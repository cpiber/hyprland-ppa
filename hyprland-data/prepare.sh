#!/bin/bash

set -xe
cd "$sourcefolder"

: Copy install assets from unstable
[ -d "$buildfolder/assets" ] || mkdir -p "$buildfolder/assets"
cp -ra ../../hyprland/source/assets/install/*.png "$buildfolder/assets"
