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
echo "## Creating orig.tar.xz, this may take a while"
# NOTE: -s for single is fine since we're not creating the debian/ folder
dh_make --createorig -p "${package}_${upstreamver}" -s -y || :

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
