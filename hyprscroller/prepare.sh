#!/bin/bash

set -xe
cd "$sourcefolder"

: Videos are only for the README
rm -rf "$buildfolder/videos"

: Get rules from hyprland-plugins
cd "$buildfolder"
sed 's/^NAME ?=.*$/NAME ?= hyprscroller/' "$sourcefolder/../../hyprland-plugins/debian/rules" > debian/rules
chmod 0775 debian/rules
