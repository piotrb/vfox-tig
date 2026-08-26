--- Returns a list of available tig versions
--- Fetches from GitHub releases API

function PLUGIN:Available(ctx)
    local http = require("http")
    local json = require("json")

    local resp, err = http.get({
        url = "https://api.github.com/repos/jonas/tig/releases",
        headers = {
            ["Accept"] = "application/vnd.github.v3+json",
        },
    })

    if err ~= nil then
        error("Failed to fetch tig releases: " .. err)
    end
    if resp.status_code ~= 200 then
        error("Failed to fetch tig releases: HTTP " .. resp.status_code)
    end

    local releases = json.decode(resp.body)
    local result = {}

    for _, release in ipairs(releases) do
        if not release.draft and not release.prerelease then
            -- Release tags look like "tig-2.6.1"; strip the "tig-" prefix for the version.
            local version = release.tag_name:gsub("^tig%-", "")
            table.insert(result, {
                version = version,
                note = release.name or "",
            })
        end
    end

    return result
end
