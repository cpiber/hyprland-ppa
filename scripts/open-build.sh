#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 {project}"
  exit 1
fi

set -xe
. "`dirname "$0"`/prepare-build.sh"
cd "$buildfolder"
package="`dpkg-parsechangelog --show-field Source`"
upstreamver="`dpkg-parsechangelog --show-field Version | sed 's/-[^-]\+$//'`"
oldpackage="`sed -n "s/^${package} (\(${upstreamver}[^)]*\)).*$/\1/p" debian/changelog | head -2 | tail -1`"
if [ ! -f "../${package}_${upstreamver}.orig.tar.xz" ]; then
  set +x
  echo "## Creating orig.tar.xz, this may take a while"

  exec 3>&1
  res="$(cd .. && wget "https://launchpad.net/~cppiber/+archive/ubuntu/hyprland/+sourcefiles/${package}/${oldpackage}/${package}_${upstreamver}.orig.tar.xz" 3>&- 2>&1 | tee /dev/fd/3; exit ${PIPESTATUS[1]})"
  rc=$?
  exec 3>&-
  set -x

  if [ $rc -ne 0 ] && echo "$res" | grep "ERROR 404" >/dev/null; then
    # NOTE: -s for single is fine since we're not creating the debian/ folder
    dh_make --createorig -p "${package}_${upstreamver}" -s -y || :
  elif [ $rc -ne 0 ]; then
    exit $rc
  fi
fi

while [ $# -gt 0 ] && [ "$1" != "--" ]; do
  shift
done
if [ $# -gt 1 ]; then
  shift # --
  exec "$@"
fi

echo "## Opening shell, run your build command, e.g. pdebuild"
shell="`getent passwd $LOGNAME | cut -d: -f7`"
shell="${shell:-/bin/sh}"
$shell
