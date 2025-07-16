#!/bin/bash

set -xe
cd "$buildfolder"

echo jammy-01-opengl.patch >> debian/patches/series
echo jammy-02-dma.patch >> debian/patches/series
echo jammy-03-cairo.patch >> debian/patches/series
echo jammy-04-libinput.patch >> debian/patches/series
patch -p1 <<- "EOF"
-- a/debian/control
+++ b/debian/control
@@ -23,7 +23,7 @@ Build-Depends:
  libcairo2-dev,
  libpango1.0-dev,
  libdrm-dev,
+ libinput-dev,
- libinput-dev (>= 1.28),
  libxcb-xfixes0-dev,
  libxcb-icccm4-dev,
  libxcb-composite0-dev,
EOF
