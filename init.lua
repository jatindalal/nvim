vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.g.clipboard = "osc52"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.scrolloff = 4
vim.o.list = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smarttab = true
vim.o.softtabstop = 0
vim.o.expandtab = false
vim.o.wrap = false
vim.o.mouse = ""
vim.o.swapfile = false
vim.o.splitbelow = true
vim.o.splitright = true

-- keymaps
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set({ "t", "i" }, "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set({ "t", "i" }, "<C-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set({ "t", "i" }, "<C-k>", "<C-\\><C-n><C-w>k")
vim.keymap.set({ "t", "i" }, "<C-l>", "<C-\\><C-n><C-w>l")
vim.keymap.set({ "n" }, "<C-h>", "<C-w>h")
vim.keymap.set({ "n" }, "<C-j>", "<C-w>j")
vim.keymap.set({ "n" }, "<C-k>", "<C-w>k")
vim.keymap.set({ "n" }, "<C-l>", "<C-w>l")
vim.keymap.set({ "n" }, "<leader>to", vim.cmd.tabnew)
vim.keymap.set({ "n" }, "<S-l>", vim.cmd.tabnext)
vim.keymap.set({ "n" }, "<S-h>", vim.cmd.tabnext)
vim.keymap.set({ "n" }, "ss", vim.cmd.split)
vim.keymap.set({ "n" }, "sv", vim.cmd.vsplit)
vim.keymap.set({ "n" }, "<leader>e", vim.cmd.Explore)
vim.keymap.set({ "n" }, "<leader>r", function()
	vim.cmd("source " .. vim.fn.stdpath("config") .. "/init.lua")
	vim.notify("Reloaded Config", vim.log.levels.INFO, {})
end)
vim.keymap.set({ "v" }, ">", ">gv")
vim.keymap.set({ "v" }, "<", "<gv")
vim.keymap.set({ "i" }, "<C-c>", "<Esc>")
vim.keymap.set({ "n" }, "<A-h>", ":vertical resize +5<Return>")
vim.keymap.set({ "n" }, "<A-l>", ":vertical resize -5<Return>")
vim.keymap.set({ "n" }, "<A-k>", ":horizontal resize +5<Return>")
vim.keymap.set({ "n" }, "<A-j>", ":horizontal resize -5<Return>")
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')

-- autocmds
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.hl.on_yank()
	end,
})
vim.api.nvim_create_autocmd("VimResized", {
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

--
-- plugins
--
vim.pack.add({
	"https://github.com/rebelot/kanagawa.nvim",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/ibhagwan/fzf-lua",
})
-- kanagawa
require("kanagawa").setup({
	transparent = true, -- do not set background color
	terminalColors = true, -- define vim.g.terminal_color_{0,17}
	colors = { theme = { all = { ui = { bg_gutter = "none" } } }, palette = {} },
	overrides = function(colors) -- add/modify highlights
		return {}
	end,
	theme = "wave", -- Load "wave" theme
	background = { -- map the value of 'background' option to a theme
		dark = "wave", -- try "dragon" !
		light = "lotus",
	},
})
vim.cmd("colorscheme kanagawa")

-- autopairs
require("nvim-autopairs").setup({})

-- fzflua
local fzf_lua = require("fzf-lua")
fzf_lua.setup({
	fzf_colors = {
		["prompt"] = { "fg", "Conditional" },
	},
})
vim.keymap.set({ "n" }, ";f", fzf_lua.files)
vim.keymap.set({ "n" }, ";r", fzf_lua.live_grep)
vim.keymap.set({ "n" }, ";;", fzf_lua.lgrep_curbuf)
vim.keymap.set({ "n" }, ";b", fzf_lua.buffers)
vim.keymap.set({ "n" }, ";c", function()
	vim.cmd("e " .. vim.fn.stdpath("config") .. "/init.lua")
end)

-- formatter
vim.pack.add({
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/stevearc/conform.nvim",
})
require("mason").setup({})
local mason_tool_installer = require("mason-tool-installer")
local formatters = {
	"stylua",
	"prettier",
	"shfmt",
	"isort",
	"clang-format",
}

-- conform
local conform = require("conform")
conform.setup({
	notify_on_error = true,
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettierd", "prettier" },
		typescript = { "prettierd", "prettier" },
		javascriptreact = { "prettierd", "prettier" },
		typescriptreact = { "prettierd", "prettier" },
		sh = { "shfmt" },
		python = { "isort", "black" },
		json = { "prettierd", "prettier" },
		markdown = { "prettier" },
		cpp = { "clang_format" },
		c = { "clang_format" },
	},
	formatters = {
		clang_format = {
			args = {
				"--style={BasedOnStyle: WebKit, IndentWidth: 4, TabWidth: 4, UseTab: Always, AccessModifierOffset: -4, Cpp11BracedListStyle: false, ReferenceAlignment: Right, PointerAlignment: Right}",
			},
		},
	},
})
vim.keymap.set({ "n" }, "<leader>f", function()
	conform.format({ async = true, lsp_format = "fallback" })
end)

-- lspconfig
vim.pack.add({
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/neovim/nvim-lspconfig",
})
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end
		map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
		map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		map("grd", vim.lsp.buf.definition, "[G]oto [D]efinition")
		map("gri", fzf_lua.lsp_implementations, "[G]oto [I]mplementation")
		map("grr", fzf_lua.lsp_references, "[G]oto [I]mplementation")
		map("K", function()
			return vim.lsp.buf.hover()
		end, "Hover")
		map("gK", function()
			return vim.lsp.buf.signature_help()
		end, "Signature Help")

		-- local client = vim.lsp.get_client_by_id(event.data.client_id)
		-- if client then
		-- 	client.server_capabilities.semanticTokensProvider = nil
		-- end
		if client and client:supports_method("textDocument/inlayHint", event.buf) then
			map("<leader>th", function()
				vim.notify("toggled inlay hint", vim.log.levels.INFO, {})
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})
vim.diagnostic.config({
	float = { border = "single", source = "if_many" },
	underline = false,
	signs = false,
})
local servers = {
	clangd = {},
	html = { filetypes = { "html", "twig", "hbs" } },
	cssls = {},
	tailwindcss = {},
	dockerls = {},
	sqlls = {},
	terraformls = {},
	jsonls = {},
	yamlls = {},
	pyright = {},
	rust_analyzer = {},
	neocmake = {},
	lua_ls = {
		on_init = function(client)
			client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if
					path ~= vim.fn.stdpath("config")
					and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
				then
					return
				end
			end

			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				runtime = {
					version = "LuaJIT",
					path = { "lua/?.lua", "lua/?/init.lua" },
				},
				workspace = {
					checkThirdParty = false,
					-- NOTE: this is a lot slower and will cause issues when working on your own configuration.
					--  See https://github.com/neovim/nvim-lspconfig/issues/3189
					library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
						"${3rd}/luv/library",
						"${3rd}/busted/library",
					}),
				},
			})
		end,
		settings = {
			Lua = {
				format = { enable = false }, -- Disable formatting (formatting is done by stylua)
			},
		},
	},
}
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, formatters)

mason_tool_installer.setup({ ensure_installed = ensure_installed })

for name, server in pairs(servers) do
	vim.lsp.config(name, server)
	vim.lsp.enable(name)
end

-- debugging
vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/theHamsta/nvim-dap-virtual-text",
	"https://github.com/jay-babu/mason-nvim-dap.nvim",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/rcarriga/nvim-dap-ui",
})

local dap = require("dap")
require("mason-nvim-dap").setup({
	automatic_installation = true,
	handlers = {},
})

local utils = require("dap.utils")
local mason_path = vim.fn.stdpath("data") .. "/mason"
local is_macos = vim.loop.os_uname().sysname == "Darwin"
local function get_active_python()
	-- 1. Activated virtualenv (POSIX / macOS / Linux)
	local venv = os.getenv("VIRTUAL_ENV")
	if venv then
		local py = venv .. "/bin/python"
		if vim.fn.executable(py) == 1 then
			return py
		end
	end

	-- 2. Conda environment
	local conda = os.getenv("CONDA_PREFIX")
	if conda then
		local py = conda .. "/bin/python"
		if vim.fn.executable(py) == 1 then
			return py
		end
	end

	-- 3. Neovim python provider (set via g:python3_host_prog)
	local host = vim.g.python3_host_prog
	if type(host) == "string" and vim.fn.executable(host) == 1 then
		return host
	end

	-- 4. Project-local .venv (common convention)
	local cwd = vim.fn.getcwd()
	local local_venv = cwd .. "/.venv/bin/python"
	if vim.fn.executable(local_venv) == 1 then
		return local_venv
	end

	-- Nothing valid found
	return ""
end

-- Configure Adapters
if is_macos then
	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = mason_path .. "/bin/codelldb",
			args = { "--port", "${port}" },
		},
	}
else
	dap.adapters.cppdbg = {
		id = "cppdbg",
		type = "executable",
		command = mason_path .. "/bin/OpenDebugAD7",
	}
end

dap.adapters.python = {
	type = "executable",
	command = mason_path .. "/packages/debugpy/venv/bin/python",
	args = {
		"-m",
		"debugpy.adapter",
	},
}

-- Configurations
local launch_config = {
	name = "Launch Executable",
	request = "launch",
	program = function()
		return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
	end,
	cwd = function()
		return vim.fn.input("cwd: ", vim.fn.getcwd() .. "/", "file")
	end,
	stopOnEntry = false,
	runInTerminal = true,
	args = function()
		-- Prompt the user for script arguments
		local input = vim.fn.input("Args: ", "", "file") -- e.g. type: arg1 arg2
		return vim.split(input, "%s+") -- split on spaces into a Lua table
	end,
	setupCommands = {
		{
			text = "-enable-pretty-printing",
			description = "enable pretty printing",
			ignoreFailures = false,
		},
	},
}

local attach_config = {
	name = "Attach to Process",
	request = "attach",
	cwd = "${workspaceFolder}",
	setupCommands = {
		{
			text = "-enable-pretty-printing",
			description = "enable pretty printing",
			ignoreFailures = false,
		},
	},
}
local launch_current_file = {
	type = "python",
	request = "launch",
	name = "Launch Current File",
	program = "${file}",
	python = function()
		return vim.fn.input("python: ", get_active_python(), "file")
	end,
	stopOnEntry = true,
	justMyCode = false,
	console = "integratedTerminal",
	cwd = function()
		return vim.fn.input("cwd: ", vim.fn.getcwd() .. "/", "file")
	end,
	args = function()
		-- Prompt the user for script arguments
		local input = vim.fn.input("Args: ", "", "file") -- e.g. type: arg1 arg2
		return vim.split(input, "%s+") -- split on spaces into a Lua table
	end,
}

local launch_file = {
	type = "python",
	request = "launch",
	name = "Launch File",
	program = function()
		return vim.fn.input("Path to python file: ", vim.fn.getcwd() .. "/", "file")
	end,
	python = function()
		return vim.fn.input("python: ", get_active_python(), "file")
	end,
	console = "integratedTerminal",
	justMyCode = false,
	cwd = function()
		return vim.fn.input("cwd: ", vim.fn.getcwd() .. "/", "file")
	end,
	args = function()
		-- Prompt the user for script arguments
		local input = vim.fn.input("Args: ", "", "file") -- e.g. type: arg1 arg2
		return vim.split(input, "%s+") -- split on spaces into a Lua table
	end,
}

if is_macos then
	launch_config.type = "codelldb"
	attach_config.type = "codelldb"
	attach_config.pid = utils.pick_process
else
	launch_config.type = "cppdbg"
	attach_config.type = "cppdbg"
	attach_config.MIMode = "gdb"
	attach_config.processId = function()
		return utils.pick_process()
	end
	attach_config.program = function()
		local pid = utils.pick_process()
		if not pid then
			return nil
		end
		return vim.fn.resolve("/proc/" .. pid .. "/exe")
	end
	-- if attach fails:
	-- sudo sysctl kernel.yama.ptrace_scope=0
end

dap.configurations.cpp = { launch_config, attach_config }
dap.configurations.c = { launch_config, attach_config }
dap.configurations.python = { launch_current_file, launch_file, attach_config }

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
vim.keymap.set({ "n" }, "<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end)
vim.keymap.set({ "n" }, "<leader>db", function()
	dap.toggle_breakpoint()
end)
vim.keymap.set({ "n" }, "<leader>dc", function()
	dap.continue()
end)
vim.keymap.set({ "n" }, "<leader>da", function()
	dap.continue({ before = get_args })
end)
vim.keymap.set({ "n" }, "<leader>dC", function()
	dap.run_to_cursor()
end)
vim.keymap.set({ "n" }, "<leader>dg", function()
	dap.goto_()
end)
vim.keymap.set({ "n" }, "<leader>di", function()
	dap.step_into()
end)
vim.keymap.set({ "n" }, "<leader>dj", function()
	dap.down()
end)
vim.keymap.set({ "n" }, "<leader>dk", function()
	dap.up()
end)
vim.keymap.set({ "n" }, "<leader>dl", function()
	dap.run_last()
end)
vim.keymap.set({ "n" }, "<leader>do", function()
	dap.step_out()
end)
vim.keymap.set({ "n" }, "<leader>dO", function()
	dap.step_over()
end)
vim.keymap.set({ "n" }, "<leader>dP", function()
	dap.pause()
end)
vim.keymap.set({ "n" }, "<leader>dr", function()
	dap.repl.toggle()
end)
vim.keymap.set({ "n" }, "<leader>ds", function()
	dap.session()
end)
vim.keymap.set({ "n" }, "<leader>dt", function()
	dap.terminate()
end)
vim.keymap.set({ "n" }, "<leader>dw", function()
	require("dap.ui.widgets").hover()
end)
local dapui = require("dapui")
dapui.setup({
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
})
vim.keymap.set({ "n" }, "<leader>du", function()
	dapui.toggle()
end)
vim.keymap.set({ "n", "v" }, "<leader>de", function()
	dapui.eval()
end)

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = nil
dap.listeners.before.event_exited["dapui_config"] = nil

require("mason-nvim-dap").setup({
	automatic_installation = true,
	handlers = {},
	ensure_installed = {
		"codelldb",
		"cppdbg",
		"debugpy",
	},
})
