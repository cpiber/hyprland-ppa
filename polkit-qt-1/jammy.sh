#!/bin/bash

set -xe
cd "$buildfolder"

echo jammy-01-qt6.patch >> debian/patches/series
