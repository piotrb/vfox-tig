--- Plugin metadata
PLUGIN = {}

PLUGIN.name = "tig"
PLUGIN.version = "0.1.0"
PLUGIN.homepage = "https://github.com/piotrb/vfox-tig"
PLUGIN.license = "GPL-2.0-only"
PLUGIN.description = "tig - text-mode interface for git"

--- Minimum vfox version required
PLUGIN.minRuntimeVersion = "0.3.0"

--- Build-time prerequisites for compiling tig from source.
--- See hooks/post_install.lua - ./configure needs a C compiler, make, and ncurses.
PLUGIN.systemDependencies = {
    { bin = "cc", packages = { apt = "build-essential", dnf = "gcc", pacman = "base-devel", apk = "build-base" } },
    { bin = "make", packages = { apt = "make", dnf = "make", pacman = "make", apk = "make" } },
    {
        pkgconfig = "ncurses",
        packages = { brew = "ncurses", apt = "libncurses-dev", dnf = "ncurses-devel", pacman = "ncurses", apk = "ncurses-dev" },
    },
}
