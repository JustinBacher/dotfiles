local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.5

return {
	---@type LazySpec
	{
		"mikavilpas/yazi.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		event = "VeryLazy",
		keys = { { "<leader>e", function() require("yazi").yazi() end, desc = "Open the file manager" } },
		opts = {
			open_for_directories = true,
			floating_window_scaling_factor = 0.7,
		},
	},
}
