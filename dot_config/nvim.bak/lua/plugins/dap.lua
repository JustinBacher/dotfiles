return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
		},
		init = function()
			vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#bf321d" })
			vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" }
			)
			vim.fn.sign_define(
				"DapBreakpointRejected",
				{ text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" }
			)
			vim.fn.sign_define(
				"DapStopped",
				{ text = "", texthl = "Dap", linehl = "DapStoppedLine", numhl = "DapStoppedLine" }
			)
		end,
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dap.listeners.before.attach.dapui_config = function() dapui.open() end
			dap.listeners.before.launch.dapui_config = function() dapui.open() end
			dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
			dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
		end,
		keys = {
			{ "<leader>dc", function() require("dap").continue() end, desc = "Debugger continue" },
			{ "<leader>dj", function() require("dap").step_over() end, desc = "Debugger step over" },
			{ "<leader>dk", function() require("dap").step_out() end, desc = "Debugger step out" },
			{ "<leader>dl", function() require("dap").step_into() end, desc = "Debugger step into" },
			{ "<leader>dt", function() require("dap").terminate() end, desc = "Debugger terminate" },
			{
				"<leader>db",
				function() require("dap").toggle_breakpoint() end,
				desc = "Debugger toggle breakpoint",
			},
			{
				"<leader>B",
				function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
				desc = "Debugger breakpoint with condition",
			},
		},
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		opts = { enabled = false },
		keys = {
			{
				"<leader>v",
				function() require("nvim-dap-virtual-text").toggle() end,
				desc = "Toggle dap virtual text",
			},
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = true,
		keys = {
			{ "<F4>", function() require("dapui").toggle() end },
		},
	},
}
