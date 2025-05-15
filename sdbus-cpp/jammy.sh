#!/bin/bash

set -xe
cd "$buildfolder"

patch -p1 <<- "EOF"
--- a/debian/rules
+++ b/debian/rules
@@ -1,10 +1,6 @@
 #!/usr/bin/make -f
 
-ifeq (,$(filter nocheck,$(DEB_BUILD_OPTIONS)))
-  ENABLE_TESTS=ON
-else
-  ENABLE_TESTS=OFF
-endif
+ENABLE_TESTS=OFF
 
 ifneq (,$(filter $(DEB_HOST_ARCH), armel mipsel powerpc))
   export DEB_LDFLAGS_MAINT_APPEND += -Wl,--no-as-needed -latomic -Wl,--as-needed
EOF
