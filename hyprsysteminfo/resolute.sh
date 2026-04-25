#!/bin/bash

set -xe
cd "$buildfolder"

echo resolute-01-private >> debian/patches/series
