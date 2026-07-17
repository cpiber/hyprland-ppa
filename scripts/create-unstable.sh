#!/bin/sh

set -xe

if [ $# -lt 1 ]; then
  echo "Usage: $0 {project}"
  exit 1
fi

stable="$1"

mkdir "$stable-unstable"
cp -ra "$stable/debian" "$stable/"*.sh "$stable-unstable"
upstream="`git -C "$stable/source" remote get-url origin`"
commit="`git -C "$stable/source" rev-parse HEAD`"

git submodule add -f "$upstream" "$stable-unstable/source"
git -C "$stable-unstable/source" checkout "$commit"
git add "$stable-unstable"

sedexpr="sed 's/$stable\([0-9]*\)/$stable\1-unstable/g'"
sedexpr2="sed 's/$stable/${stable}_unstable/g'"
: Rename packages
sed -i "s/$stable\([0-9]*\)/$stable\1-unstable/g" "$stable-unstable/debian/control"
sed -i "s/$stable\([0-9]*\)/$stable\1-unstable/g" "$stable-unstable/debian/changelog"
: Add patchelf dep
sed -i 's/Build-Depends:/Build-Depends:\
 patchelf,/' "$stable-unstable/debian/control"
: Rename installation files
find "$stable-unstable/debian" \( -name '*.dirs' -o -name '*.install' -o -name '*.docs' \) -execdir sh -c 'mv "$1" "`echo "$1" | '"$sedexpr"'`"' sh \{\} \;
: Append so rename
d='$'
cat << EOF >> "$stable-unstable/debian/rules"

override_dh_auto_install:
	dh_auto_install

	cd debian/tmp/usr/lib/$d(DEB_HOST_MULTIARCH)/; for f in *.so; do if [ -L "$d${d}f" ]; then ln -sfn "$d$d(readlink "$d${d}f" | $sedexpr2)" "$d${d}f"; fi; mv "$d${d}f" "$d$d(echo "$d${d}f" | $sedexpr2)"; done
	cd debian/tmp/usr/lib/$d(DEB_HOST_MULTIARCH)/; for f in *.so.*; do if [ -L "$d${d}f" ]; then ln -sfn "$d$d(readlink "$d${d}f" | $sedexpr2)" "$d${d}f"; fi; mv "$d${d}f" "$d$d(echo "$d${d}f" | $sedexpr2)"; done
	cd debian/tmp/usr/lib/$d(DEB_HOST_MULTIARCH)/; for f in *.so; do if [ ! -L "$d${d}f" ]; then patchelf --set-soname "$d$d(patchelf --print-soname "$d${d}f" | $sedexpr2)" "$d${d}f"; fi; done
	cd debian/tmp/usr/lib/$d(DEB_HOST_MULTIARCH)/; for f in *.so.*; do if [ ! -L "$d${d}f" ]; then patchelf --set-soname "$d$d(patchelf --print-soname "$d${d}f" | $sedexpr2)" "$d${d}f"; fi; done
	sed -i 's/-l$stable/-l${stable}_unstable/g' debian/tmp/usr/lib/$d(DEB_HOST_MULTIARCH)/pkgconfig/$stable.pc
EOF

