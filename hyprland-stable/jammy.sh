#!/bin/bash

set -xe
cd "$buildfolder"

echo jammy-01-opengl.patch >> debian/patches/series
