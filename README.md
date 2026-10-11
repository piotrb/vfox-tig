# vfox-tig

A [vfox](https://github.com/version-fox/vfox) plugin for [tig](https://jonas.github.io/tig/) - a text-mode interface for git.

tig only publishes source tarballs, so this plugin builds tig from source on install.

## Requirements

Building tig requires a C compiler, `make`, `pkg-config`, and ncurses development headers. These
are declared as `systemDependencies` in `metadata.lua`, so mise checks for them
before installing and - depending on your `system_deps` setting - can report,
offer to install, or auto-install anything missing.

If you'd rather install them yourself first:

| OS                     | Command                                            |
| ---------------------- | --------------------------------------------------- |
| Debian/Ubuntu           | `sudo apt-get install build-essential pkg-config libncurses-dev` |
| Fedora/RHEL             | `sudo dnf install gcc make pkgconf-pkg-config ncurses-devel`             |
| Arch                    | `sudo pacman -S base-devel pkgconf ncurses`                   |
| macOS (Homebrew)        | `xcode-select --install && brew install pkgconf ncurses`      |

If a build step still fails, the error includes the full `configure`/`make` output,
which usually names the missing dependency directly.

Windows is not supported, since the build relies on `./configure` and `make`.

## Installation

```bash
# With mise
mise install vfox:piotrb/vfox-tig@2.6.1

# With vfox
vfox add piotrb/vfox-tig
vfox install tig@2.6.1
```

## Usage

```bash
# With mise
mise use vfox:piotrb/vfox-tig@2.6.1
tig --version

# Or run directly
mise x vfox:piotrb/vfox-tig@2.6.1 -- tig --version
```

## How it works

1. Versions are read from the [jonas/tig releases](https://github.com/jonas/tig/releases) on GitHub.
2. The matching `tig-<version>.tar.gz` source tarball (and its `.sha256` checksum, when published) is downloaded and extracted.
3. `./configure`, `make`, and `make install` are run against the extracted source, installing into an `install/` sub-folder kept separate from the build tree.
4. `PATH` is pointed at that sub-folder's `bin/` directory.

## License

Apache-2.0 for this plugin. tig itself is licensed under GPL-2.0-only.
