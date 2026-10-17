return {
    {
        "stevearc/conform.nvim",
        opts = {
            formatters = {
                taplo = {
                    -- Pass the project-specific taplo config file to the taplo CLI
                    prepend_args = function(self, ctx)
                        -- Check for both taplo.toml and .taplo.toml at your project root
                        local config_path =
                            require("conform.util").find_file({ "taplo.toml", ".taplo.toml" })(self, ctx)
                        if config_path then
                            return { "--config", config_path }
                        end
                        return {}
                    end,
                },
            },
        },
    },
}
