#!/bin/sh

if [ $# -lt 1 ]; then
  echo "Usage: $0 {project}"
  exit 1
fi

sethyprver() {
  hyprver="`head -n1 "$reporoot/hyprland/debian/changelog" | sed 's/.*(\([^)]*\)).*/\1/'`"
  # NOTE: The ~ in the first dependency sorts before all, so any suffix is allowed, including none
  # The second line uses 9 as suffix, which sorts the lowest
  # Together, this depends on exactly this upstream and debian version, but allows any suffix including none
  sed -i 's/^ hyprland-unstable .*/ hyprland-unstable (>= '$hyprver'~), hyprland-unstable (<< '$hyprver'9),/w /dev/stdout' "$reporoot/$project/debian/control" | grep -q .
}

set -xe
reporoot="`cd "$(dirname "$0")/.." && pwd`"

project="$1"
shift
sourcefolder="$reporoot/$project/source"
case "$project" in
  hyprland|hyprland-plugins)
    type="main"
    ;;
  waybar-unstable|hyprscroller|hy3)
    type="master"
    ;;
  *)
    type="tag"
    ;;
esac

cd "$sourcefolder"
curhead="`git rev-parse HEAD`"
if [ "$type" != "tag" ]; then
  git checkout "$type"
  git pull --quiet --rebase
  tag="`git describe --tags | sed 's/-[0-9]\+-g[0-9a-fA-F]\+//g'`"
  tag="`echo "$tag" | sed 's/^[^0-9]*\([0-9.]\+\).*/\1/'`"
else
  git fetch --tags
  tag="`git describe --tags origin | sed 's/-[0-9]\+-g[0-9a-fA-F]\+//'`"
  git checkout "$tag"
  tag="`echo "$tag" | sed 's/^[^0-9]*\([0-9.]\+\).*/\1/'`"
fi
git submodule update --init --recursive
newhead="`git rev-parse HEAD`"
shorthead="`git rev-parse --short HEAD`"
if [ "$curhead" = "$newhead" ]; then
  echo "Already up-to-date"
  if [ "$project" = "hyprland-plugins" ] || [ "$project" = "hyprscroller" ] || [ "$project" = "hy3" ]; then
    if sethyprver; then
      cd ..
      dist="`dpkg-parsechangelog --show-field Distribution`"
      dch -D "$dist" -R "$@" "Rebuild for unstable"
    fi
  fi
  exit 1
fi
changes="`git log --pretty="%h %s" $curhead..$newhead`"
cd ..
dist="`dpkg-parsechangelog --show-field Distribution`"
if [ "$type" != "tag" ]; then
  curver="`dpkg-parsechangelog --show-field Version | sed 's/+git.*//'`"
  curtag="`dpkg-parsechangelog --show-field Version | sed 's/~.*//'`"
  [ "$curtag" = "$tag" ] || [ "$tag" = "" ] || curver="$tag~1ppa1"
  newver="$curver+git`date "+%Y%m%d%H%M"`-$shorthead"
  dch -v "$newver" -D "$dist" "$@" "Update to $type $shorthead"
else
  newver="$tag-1ppa1"
  dch -v "$newver" -D "$dist" "$@" "Update to release $tag"
fi
echo "$changes" |
  while IFS= read -r line; do
    dch -a "$line"
  done
if [ "$project" = "hyprland-plugins" ] || [ "$project" = "hyprscroller" ] || [ "$project" = "hy3" ]; then
  sethyprver
fi
