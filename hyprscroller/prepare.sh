#!/bin/bash

set -xe
cd "$sourcefolder"

: Videos are only for the README
rm -rf "$buildfolder/videos"
