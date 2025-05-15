#!/bin/bash

set -xe
cd "$buildfolder"

echo jammy-01-pipewire.patch >> debian/patches/series
patch -p1 <<- "EOF"
--- a/debian/control
+++ b/debian/control
@@ -16,7 +16,7 @@
  wayland-protocols,
  libwayland-bin,
  libwayland-dev,
- libpipewire-0.3-dev (>= 1.1.82),
+ libpipewire-0.3-dev (>= 0.3.65),
  libspa-0.2-dev,
  libdrm-dev,
  libgbm-dev,
EOF
