#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 {project}"
  exit 1
fi

set -xe
. "`dirname "$0"`/prepare-build.sh"
cd "$buildfolder"
package="`dpkg-parsechangelog --show-field Source`"
upstreamver="`dpkg-parsechangelog --show-field Version | sed 's/-[^-]\+//'`"
oldpackage="`sed -n "s/^${package} (\(${upstreamver}[^)]*\)).*$/\1/p" debian/changelog | tail -n1`"
if [ ! -f "../${package}_${upstreamver}.orig.tar.xz" ]; then
  echo "## Creating orig.tar.xz, this may take a while"
  if !(cd .. && wget "https://launchpad.net/~cppiber/+archive/ubuntu/hyprland/+sourcefiles/${package}/${oldpackage}/${package}_${upstreamver}.orig.tar.xz"); then
    # NOTE: -s for single is fine since we're not creating the debian/ folder
    dh_make --createorig -p "${package}_${upstreamver}" -s -y || :
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
