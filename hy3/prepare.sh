#!/bin/bash

set -xe
cd "$sourcefolder"

: Get rules from hyprland-plugins
cd "$buildfolder"
sed 's/^NAME ?=.*$/NAME ?= hy3/' "$sourcefolder/../../hyprland-plugins/debian/rules" > debian/rules
chmod 0775 debian/rules
