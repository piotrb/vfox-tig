--- Returns download info for the tig source tarball of the requested version
--- tig only publishes source tarballs, so this plugin builds from source
--- (see hooks/post_install.lua).

function PLUGIN:PreInstall(ctx)
    local http = require("http")
    local json = require("json")

    local version = ctx.version
    if version == nil or version == "" then
        error("You must provide a version number, eg: vfox install tig@2.6.1")
    end

    if RUNTIME.osType == "windows" then
        error("This plugin builds tig from source using make and is not supported on Windows")
    end

    local tag = "tig-" .. version

    local resp, err = http.get({
        url = "https://api.github.com/repos/jonas/tig/releases/tags/" .. tag,
        headers = {
            ["Accept"] = "application/vnd.github.v3+json",
        },
    })

    if err ~= nil then
        error("Failed to fetch tig release " .. tag .. ": " .. err)
    end
    if resp.status_code ~= 200 then
        error("Failed to fetch tig release " .. tag .. ": HTTP " .. resp.status_code)
    end

    local release = json.decode(resp.body)

    local tarball_name = "tig-" .. version .. ".tar.gz"
    local checksum_name = tarball_name .. ".sha256"
    local download_url = nil
    local checksum_url = nil

    for _, asset in ipairs(release.assets or {}) do
        if asset.name == tarball_name then
            download_url = asset.browser_download_url
        elseif asset.name == checksum_name then
            checksum_url = asset.browser_download_url
        end
    end

    if download_url == nil then
        error("Could not find source tarball " .. tarball_name .. " for release " .. tag)
    end

    -- Older releases only shipped an .md5 checksum, or none at all; sha256 is best-effort.
    local sha256 = nil
    if checksum_url ~= nil then
        local checksum_resp, checksum_err = http.get({ url = checksum_url })
        if checksum_err == nil and checksum_resp.status_code == 200 then
            -- Format is: "checksum  filename\n"
            sha256 = checksum_resp.body:match("^(%x+)")
        end
    end

    return {
        version = version,
        url = download_url,
        sha256 = sha256,
    }
end
