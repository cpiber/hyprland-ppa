# hyprland-ppa

This repository contains the `debian/` files for my PPA.
These files detail the recipe for building a .deb package.
Currently these work for Ubuntu 24.04 Noble and 24.10 Oracular.

Published packages are available here: https://launchpad.net/~cppiber/+archive/ubuntu/hyprland

## Packages

Packages are organized into subfolders.
Each package contains two folders: `debian/` and `source/`.
The source code of the packages is not stored here and instead embedded as a git submodule.
Hence, the debian subdirectory instead does not live in the source code.
This repository contains some scripts to deal with this.

To initialize all packages:

```console
$ git clone https://github.com/cpiber/hyprland-ppa.git  # Clone this repository
$ git submodule update --init --recursive  # Fetch all package sources
```

## Scripts

### Updating a package

```console
$ ./scripts/update.sh <package>
```

This script will fetch the latest changes for the specified package.
All packages except `hyprland` and `waybar-unstable` will check out the lastest tag.
The two mentioned exceptions will check out the lastest commit on main/master.

The script additionally generates the appropriate changelog from the commit names.
If the version did not change, the script exists with code 1 and does not apply any changes.

### Building a package

```console
$ ./scripts/open-build.sh <package> [<distribution>]
```

This script prepares a build area in `/tmp/hyprland-ppa/` and opens a shell there for building.
It copies both the `source/` and `debian/` folders together into the expected structure.
Some packages additionally contain a `prepare.sh` file, which is executed in the resulting build environment.
This may be used to exclude files from the final archive.

As the last step, the script generates the `<package>_<version>.orig.tar.xz` file necessary for building the package.
The actual build is left to the user.

The optional `<distribution>` argument may be used to build a separate version for a different distribution than specified in the `debian/` folder.
This option generates a new entry in the changelog and appends `~1<distribution>1` to the version field, allowing a rebuild with no changes for this distribution.
Make sure to use the same orig file, as launchpad refuses to accept one with a different checksum.

Information about my build setup: https://github.com/cpiber/ppa/blob/main/build.md

### No-change rebuild

```console
$ ./scripts/rebuild.sh <package>
$ ./scripts/rebuild-depends.sh <packages...>
```

The first script simply increments the patch part of the version number (new changelog entry).
This allows a rebuild of the package when no source changes were found, as necessary when a dependency changes (with ABI changes) or a new patch is introduced.

The second script instead takes a package name (or multiple) and asks `apt-cache` for dependents.
It then calls the former script to rebuild all reverse dependencies.
Use this when a breaking change is introduced and a new build needs to be kicked off for depending packages.

See [Building a package](#building-a-package) for actually starting the build.

### Working with patches

The unconventional location of the `debian/` folder means existing tooling will not automatically pick it up.
When working with `quilt`, I recommend the following setting:

```console
$ export QUILT_PATCHES=../debian/patches
```

With this, `quilt` will pick up the patches and patches can be applied as usual, see [the manual](https://www.debian.org/doc/manuals/maint-guide/modify.en.html).
