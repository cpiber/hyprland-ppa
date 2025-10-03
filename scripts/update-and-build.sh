#!/bin/bash

buildone() {
  if [ "${2:-}" != "-s" ]; then
    if ! ./scripts/update.sh "$1"; then
      return 1
    fi
  fi
  for dist in "" plucky questing jammy; do
    if ! ./scripts/open-build.sh "$1" "$dist" -- bash -c 'dpkg-buildpackage --build=source --no-check-builddeps -kE7A507C32F5C2FA37F32BBABB1EC1F940FA20E58 && debrelease -S --dput ppa:cppiber/hyprland'; then
      return 1
    fi
  done
}

buildplugin() {
  if [ "${2:-}" != "-s" ]; then
    ./scripts/update.sh "$1" || :
  fi
  for dist in "" plucky questing; do
    if ! ./scripts/open-build.sh "$1" "$dist" -- bash -c 'dpkg-buildpackage --build=source --no-check-builddeps -kE7A507C32F5C2FA37F32BBABB1EC1F940FA20E58 && debrelease -S --dput ppa:cppiber/hyprland'; then
      return 1
    fi
  done
}

set -xe
cd "$(dirname "$0")/.."

if [ $# -gt 0 ]; then
  project="$1"
  case "$project" in
    hyprland-plugins|hyprscroller|hy3|hyprspace|hyprsplit)
      buildplugin "$@"
      ;;
    *)
      buildone "$@"
      ;;
  esac

  if [ "$project" = "hyprland" ] && [ "${2:-}" != "-s" ]; then
    buildplugin "hyprland-plugins" "${2:-}"
    buildplugin "hyprscroller" "${2:-}"
    buildplugin "hy3" "${2:-}"
    buildplugin "hyprspace" "${2:-}"
    buildplugin "hyprsplit" "${2:-}"
  fi
else
  for project in aquamarine hypr* xdg-desktop-portal-hyprland; do
    rc=0
    case "$project" in
      hyprland-plugins|hyprscroller|hy3|hyprspace|hyprsplit)
        ;;
      *)
        buildone "$project" || rc=$?
        ;;
    esac

    if [ "$rc" -ne 0 ]; then
      echo "### ERROR UPDATING/BUILDING $project ###"
    fi

    if [ "$project" = "hyprland" ] && [ "$rc" -eq 0 ]; then
      buildplugin "hyprland-plugins" "${2:-}"
      buildplugin "hyprscroller" "${2:-}"
      buildplugin "hy3" "${2:-}"
      buildplugin "hyprspace" "${2:-}"
      buildplugin "hyprsplit" "${2:-}"
    fi
  done
fi
