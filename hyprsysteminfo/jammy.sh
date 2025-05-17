#!/bin/bash

set -xe
cd "$buildfolder"

echo jammy-02-qt6.patch >> debian/patches/series
patch -p1 <<- "EOF"
--- a/debian/control
+++ b/debian/control
@@ -19,6 +19,8 @@
  qt6-wayland-private-dev,
  qt6-declarative-dev,
- qt6-svg-dev,
+ libqt6opengl6-dev,
+ libwayland-dev,
+ qt6-wayland-dev-tools,
 Standards-Version: 4.6.2
 Homepage: https://hyprland.org
 Vcs-Browser: https://github.com/hyprwm/hyprsysteminfo
@@ -34,7 +37,6 @@
  qml6-module-qtquick-layouts,
  qml6-module-qtquick-templates,
  qml6-module-qtqml-workerscript,
- hyprland-qt-support0,
  qt6-qpa-plugins,
  qt6-wayland,
  libqt6svg6,
EOF
