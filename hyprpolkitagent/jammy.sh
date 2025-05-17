#!/bin/bash

set -xe
cd "$buildfolder"

echo jammy-02-qt6.patch >> debian/patches/series
patch -p1 <<- "EOF"
--- a/debian/control
+++ b/debian/control
@@ -17,6 +17,9 @@
  qt6-base-dev,
  qt6-base-private-dev,
  qt6-declarative-dev,
+ libqt6opengl6-dev,
+ libwayland-dev,
+ qt6-wayland-dev-tools,
 Standards-Version: 4.6.2
 Homepage: https://hyprland.org
 Vcs-Browser: https://github.com/hyprwm/hyprpolkitagent
EOF
