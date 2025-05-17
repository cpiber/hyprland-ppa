#!/bin/bash

set -xe
cd "$buildfolder"

echo jammy-02-qt6.patch >> debian/patches/series
patch -p1 <<- "EOF"
--- a/debian/control
+++ b/debian/control
@@ -18,6 +18,9 @@
  qt6-wayland-dev,
  qt6-wayland-private-dev,
  qt6-declarative-dev,
+ libqt6opengl6-dev,
+ libwayland-dev,
+ qt6-wayland-dev-tools,
 Standards-Version: 4.6.2
 Homepage: https://hyprland.org
 Vcs-Browser: https://github.com/hyprwm/hyprland-qtutils
@@ -33,7 +36,6 @@
  qml6-module-qtquick-layouts,
  qml6-module-qtquick-templates,
  qml6-module-qtqml-workerscript,
- hyprland-qt-support0,
  qt6-qpa-plugins,
  libqt6svg6,
 Description: Some qt/qml utilities that might be used by hypr apps
EOF
