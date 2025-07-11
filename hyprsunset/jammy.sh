#!/bin/bash

set -xe
cd "$buildfolder"

echo jammy-01-cmake.patch >> debian/patches/series
