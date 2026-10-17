return {
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            kotlin_language_server = {
                cmd_env = {
                    JAVA_HOME = "/usr/lib/jvm/java-11-openjdk",
                },
            },
            ["rust_analyzer"] = {
                cargo = { allTargets = false },
                check = { allTargets = false },
            },
        },
    },
}
