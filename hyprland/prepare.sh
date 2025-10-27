#!/bin/bash

set -xe
cd "$sourcefolder"

: Remove subprojects, we use direct dependencies
rm -rf "$buildfolder/subprojects"

: Remove assets, we package them separately
rm --interactive=never "$buildfolder/assets/install/"*.png

: Hardcode version from git in patch
cat "$debianfolder/patches/00-version" |
  while IFS= read -r line; do
    case "$line" in
      +##*)
        cmd="`echo "$line" | sed 's/+## //;s/"/\\"/g'`"
        echo "$line"
        IFS= read -r line
        result="`eval "$cmd" | sed 's/ \+$//'`"
        printf '%s%s%s\n' "`echo "$line" | sed 's/<result>.*//'`" "$result" "`echo "$line" | sed 's/.*<result>//'`"
        ;;
      *)
        echo "$line"
        ;;
    esac
  done > "$buildfolder/debian/patches/00-version"
