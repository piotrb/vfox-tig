--- Sets environment variables for the installed tig version

function PLUGIN:EnvKeys(ctx)
    local sdkInfo = ctx.sdkInfo["tig"]
    local installPath = sdkInfo.path .. "/install"

    return {
        {
            key = "PATH",
            value = installPath .. "/bin",
        },
    }
end
