--- Builds tig from the extracted source tarball and installs it into a
--- dedicated "install" sub-folder, keeping the build tree and the installed
--- tree separate.
--- Requires a C compiler, make, and ncurses development headers on PATH.

-- Runs a build step, capturing its full stdout+stderr to a log file so that a
-- failure can surface more than vfox's default one-line summary (e.g. the
-- real reason `configure` gave up, not just its exit status).
local function run_step(cmd, cwd, env, label, command)
    local file = require("file")
    local logPath = file.join_path(cwd, label .. ".log")

    local ok = pcall(cmd.exec, command .. ' > "' .. logPath .. '" 2>&1', { cwd = cwd, env = env })
    if not ok then
        local output = file.exists(logPath) and file.read(logPath) or "(no output captured)"
        error(
            "tig build step '"
                .. label
                .. "' failed. Full output below.\n\n"
                .. output
                .. "\n\nSee README.md for required build dependencies (C compiler, make, ncurses headers)."
        )
    end
end

function PLUGIN:PostInstall(ctx)
    local cmd = require("cmd")
    local file = require("file")

    local sdkInfo = ctx.sdkInfo["tig"]
    local srcPath = sdkInfo.path
    local installPath = file.join_path(srcPath, "install")

    local env = {
        PREFIX = installPath,
    }

    run_step(cmd, srcPath, env, "configure", './configure --prefix="$PREFIX"')
    run_step(cmd, srcPath, env, "make", 'make -j"$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)"')
    run_step(cmd, srcPath, env, "make-install", "make install")

    local binPath = file.join_path(installPath, "bin", "tig")
    if not file.exists(binPath) then
        error("Failed to build tig - binary not found at " .. binPath)
    end
end
