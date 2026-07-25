#!/bin/bash

buildone() {
  local rc=0
  if [ "${2:-}" != "-s" ]; then
    ./scripts/update.sh "$@" || rc=$?
    if [ $rc -ne 0 ]; then
      return $rc
    fi
  fi
  for dist in "" resolute; do
    if ! ./scripts/open-build.sh "$1" "$dist" -- bash -c "dpkg-buildpackage --build=source --no-check-builddeps ${DPKG_BUILDPKG_ADDITIONAL_ARGS:-} && debrelease -S --dput '${DPUT_PPA:-ppa:cppiber/hyprland}'"; then
      return 1
    fi
  done
}

buildplugin() {
  if [ "${2:-}" != "-s" ]; then
    ./scripts/update.sh "$@" || :
  fi
  for dist in "" resolute; do
    if ! ./scripts/open-build.sh "$1" "$dist" -- bash -c "dpkg-buildpackage --build=source --no-check-builddeps ${DPKG_BUILDPKG_ADDITIONAL_ARGS:-} && debrelease -S --dput '${DPUT_PPA:-ppa:cppiber/hyprland}'"; then
      return 1
    fi
  done
}

set -xe
cd "$(dirname "$0")/.."

if [ -f scripts/.env.sh ]; then
  . scripts/.env.sh
fi

if [ $# -gt 0 ]; then
  project="$1"
  case "$project" in
    all-plugins)
      buildplugin "hyprland-plugins" "${2:-}"
      buildplugin "hy3" "${2:-}"
      buildplugin "hyprspace" "${2:-}"
      buildplugin "hyprsplit" "${2:-}"
      ;;
    hyprland-plugins|hyprscroller|hy3|hyprspace|hyprsplit)
      buildplugin "$@"
      ;;
    *)
      buildone "$@"
      ;;
  esac

  if [ "$project" = "hyprland" ] && [ "${2:-}" != "-s" ]; then
    buildplugin "hyprland-plugins" "${2:-}"
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
      buildplugin "hy3" "${2:-}"
      buildplugin "hyprspace" "${2:-}"
      buildplugin "hyprsplit" "${2:-}"
    fi
  done
fi
