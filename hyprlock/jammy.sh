#!/bin/bash

set -xe
cd "$buildfolder"

echo jammy-01-opengl.patch >> debian/patches/series
echo jammy-02-cairo.patch >> debian/patches/series
echo jammy-03-pam.patch >> debian/patches/series
