#!/bin/bash

set -xe
cd "$sourcefolder"

: Remove subprojects, we use direct dependencies
rm -rf "$buildfolder/subprojects"
rm -rf "$buildfolder/3rd-party"
rm -rf "$buildfolder/nanosvg"
