#!/bin/bash

set -xe
cd "$buildfolder"

echo jammy-01-opengl.patch >> debian/patches/series
echo jammy-02-dma.patch >> debian/patches/series
echo jammy-03-cairo.patch >> debian/patches/series
