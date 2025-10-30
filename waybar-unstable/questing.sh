#!/bin/bash

set -xe
cd "$buildfolder"

patch -p1 <<- "EOF"
-- a/debian/control
+++ b/debian/control
@@ -6,7 +6,7 @@ Uploaders: Birger Schacht <birger@debian.org>,
            Constantin Piber <cp.piber@gmail.com>
 Build-Depends:
  debhelper-compat (= 13),
- libwlroots-dev,
+ libwlroots-0.18-dev,
  libwayland-dev,
  libinput-dev,
  meson,
EOF
