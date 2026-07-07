return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			{
				"mason-org/mason.nvim",
				opts = {},
			},
			"jay-babu/mason-nvim-dap.nvim",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			require("mason-nvim-dap").setup({
				automatic_installation = true,
				handlers = {},
			})
			require("plugins.dap.cpp")
			require("plugins.dap.python")
			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
			local dap_icons = {
				Stopped = { "▶", "DiagnosticWarn", "DapStoppedLine" },
				Breakpoint = "●",
				BreakpointCondition = "◐",
				BreakpointRejected = "○",
				LogPoint = "◆",
			}

			for name, sign in pairs(dap_icons) do
				local icon = type(sign) == "table" and sign or { sign }
				vim.fn.sign_define(
					"Dap" .. name,
					{ text = icon[1], texthl = icon[2] or "DiagnosticInfo", linehl = icon[3], numhl = icon[3] }
				)
			end

			-- setup dap config by VsCode launch.json file
			local vscode = require("dap.ext.vscode")
			local json = require("plenary.json")
			vscode.json_decode = function(str)
				return vim.json.decode(json.json_strip_comments(str))
			end
		end,

		-- stylua: ignore
		keys = {
		    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
		    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
		    { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
		    { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
		    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
		    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
		    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
		    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
		    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
		    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
		    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
		    { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
		    { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
		    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
		    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
		    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
		    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		opts = {
			icons = {
				expanded = "▾",
				collapsed = "▸",
				current_frame = "▸",
			},
			controls = {
				icons = {
					pause = "॥",
					play = "▶",
					step_into = "↓",
					step_over = "↷",
					step_out = "↑",
					step_back = "↺",
					run_last = "⟳",
					terminate = "■",
					disconnect = "⏏",
				},
			},
		},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = nil
			dap.listeners.before.event_exited["dapui_config"] = nil
		end,
		keys = {
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "Toggle DAP UI",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				mode = { "n", "v" },
				desc = "Evaluate Expression",
			},
		},
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		opts = {},
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		opts = {
			automatic_installation = true,
			handlers = {},
			ensure_installed = {
				"codelldb",
				"cppdbg",
				"debugpy",
			},
		},
	},
}
