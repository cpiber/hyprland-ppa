#!/bin/bash

set -xe
cd "$buildfolder"

echo jammy-01-cmake.patch >> debian/patches/series
patch -p1 <<- "EOF"
--- a/debian/control
+++ b/debian/control
@@ -14,7 +14,6 @@
  libhyprutils-dev,
  libjpeg-dev,
  libwebp-dev,
- libjxl-dev,
  libmagic-dev,
  libspng-dev,
 Standards-Version: 4.6.2
EOF
