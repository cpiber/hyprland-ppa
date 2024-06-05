#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 {project}"
  exit 1
fi

set -xe
. "`dirname "$0"`/prepare-build.sh"
shell="`getent passwd $LOGNAME | cut -d: -f7`"
shell="${shell:-/bin/sh}"
cd "$buildfolder"
$shell
