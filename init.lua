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
vim.o.expandtab = true
vim.o.wrap = false
vim.o.mouse = ""
vim.o.swapfile = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.synmaxcol = 240
vim.o.updatetime = 200
vim.o.redrawtime = 10000
vim.o.maxmempattern = 20000
vim.o.termguicolors = true
vim.opt.listchars = {
	tab = "▸ ",
	trail = "·",
	extends = "❯",
	precedes = "❮",
	nbsp = "␣",
}
vim.o.cmdheight = 0
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.opt.fillchars:append({ eob = " " })
vim.o.exrc = true
vim.o.secure = true

-- keymaps
vim.keymap.set({ "t" }, "<Esc>", "<C-\\><C-n>")
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
vim.keymap.set({ "n" }, "<S-h>", vim.cmd.tabprev)
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
vim.keymap.set({ "n" }, "x", '"_x', opts)
vim.keymap.set("n", "<leader>lg", function()
	vim.cmd.tabnew()
	vim.cmd("terminal lazygit")
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_create_autocmd("TermClose", {
		buffer = buf,
		once = true,
		callback = function()
			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(buf) then
					vim.api.nvim_buf_delete(buf, { force = true })
				end
			end)
		end,
	})
	vim.cmd.startinsert()
end, { desc = "Open lazygit" })
vim.keymap.set("t", "<Esc>", function()
	local name = vim.api.nvim_buf_get_name(0)
	if name:match("lazygit") then
		return "<Esc>"
	end
	return "<C-\\><C-N>"
end, { expr = true })
vim.keymap.set({ "n", "v" }, "<leader>", "<nop>")
vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ silent = false, desc = "Search and replace word under cursor" }
)

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
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})
vim.api.nvim_create_autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("dotenv_ft", { clear = true }),
	pattern = { ".env", ".env.*" },
	callback = function()
		vim.bo.filetype = "dosini"
	end,
})

local ignore_patterns = {
	-- "node_modules",
	-- "%.git",
	-- "%.cache",
	-- "dist",
	-- "build",
	-- "%.tmp",
	-- "%.log",
}

function _G.native_find(text, _)
	local files = vim.fn.glob("**/*", true, true)
	local result = {}
	for _, f in ipairs(files) do
		if vim.fn.isdirectory(f) == 0 then
			local skip = false
			for _, pat in ipairs(ignore_patterns) do
				if f:match(pat) then
					skip = true
					break
				end
			end
			if not skip then
				result[#result + 1] = f
			end
		end
	end
	return vim.fn.matchfuzzy(result, text)
end
vim.opt.findfunc = "v:lua.native_find"

vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.api.nvim_create_user_command("Grep", function(opts)
	local pattern = opts.args

	if pattern == "" then
		vim.ui.input({ prompt = "Grep: " }, function(input)
			if input and input ~= "" then
				vim.cmd("silent grep! " .. vim.fn.fnameescape(input))
				vim.cmd("copen")
			end
		end)
	else
		vim.cmd("silent grep! " .. vim.fn.fnameescape(pattern))
		vim.cmd("copen")
	end
end, {
	nargs = "?",
})

--
-- plugins
--
local function gh(repo)
	return "https://github.com/" .. repo
end

-- colorscheme
vim.pack.add({
	gh("rebelot/kanagawa.nvim"),
})
require("kanagawa").setup({
	commentStyle = { italic = false },
	keywordStyle = { italic = false },
	transparent = true,
	colors = {
		theme = {
			all = { ui = {
				bg_gutter = "none",
			} },
		},
	},
	overrides = function(colors)
		return {
			LineNr = { fg = "#999988" },
			TabLine = { bg = "#050403", fg = "#666666" },
			TabLineSel = { bg = "#060504" },
			TabLineFill = { bg = "none" },
			NormalFloat = { bg = "none" },
			FloatBorder = { bg = "none" },
			Folded = { fg = "#ccccaa", bg = "none" },
			StatusLine = { bg = "none" },
			StatusLineNC = { bg = "none", fg = "#666666" },
			Whitespace = { fg = "#444444" },
			Normal = { bg = "#080808" },
			TelescopeBorder = { fg = "#ccccbb", bg = "none" }
		}
	end,
})
vim.cmd.colorscheme("kanagawa")

-- editor
vim.pack.add({
	gh("windwp/nvim-autopairs"),
	gh("tpope/vim-fugitive"),
})
require("nvim-autopairs").setup({})

-- picker
vim.pack.add({
	gh("nvim-telescope/telescope.nvim"),
	gh("nvim-lua/plenary.nvim"),
	gh("nvim-telescope/telescope-ui-select.nvim"),
})
require("telescope").setup({
	pickers = {
		find_files = {
			file_ignore_patterns = { "node_modules", ".git", ".venv", "build" },
			hidden = true,
			previewer = false,
		},
		live_grep = {
			previewer = false,
			file_ignore_patterns = { "node_modules", ".git", ".venv" },
			additional_args = function(_)
				return { "--hidden" }
			end,
		},
		buffers = {
			previewer = false,
		},
		current_buffer_fuzzy_find = {
			previewer = false,
		},
	},
})
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")
local builtin = require("telescope.builtin")
vim.keymap.set("n", ";f", function() builtin.find_files() end)
vim.keymap.set("n", ";r", function() builtin.live_grep() end)
vim.keymap.set("n", ";l", function() builtin.current_buffer_fuzzy_find() end)
vim.keymap.set("n", ";b", function() builtin.buffers() end)
vim.keymap.set("n", ";c", function() vim.cmd("e " .. vim.fn.stdpath("config") .. "/init.lua") end)

-- files
vim.pack.add({
	gh("nvim-mini/mini.files"),
	gh("nvim-mini/mini.icons"),
})
require("mini.icons").setup({ style = "ascii" })
require("mini.files").setup({
	options = { use_as_default_explorer = true },
	mappings = { go_in_plus = "<CR>" },
	windows = {
		preview = false,
	},
})

vim.keymap.set("n", "<leader>e", function()
	if not MiniFiles.close() then
		MiniFiles.open(vim.uv.cwd(), true)
	end
end)
vim.keymap.set("n", "<leader>E", function()
	if not MiniFiles.close() then
		MiniFiles.open(vim.uv.cwd(), false)
	end
end)

-- formatter
vim.pack.add({
	gh("stevearc/conform.nvim"),
})
local conform = require("conform")
conform.setup({
	notify_on_error = true,
	formatters_by_ft = {
		lua = { "stylua" },
		sh = { "shfmt" },
		python = { "black", "ruff_format" },
		json = { "prettier", "jq" },
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
vim.keymap.set({ "n", "v" }, "<leader>f", function()
	conform.format({ async = true, lsp_format = "fallback" })
end)

-- lsp
vim.pack.add({
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
		map("grd", builtin.lsp_definitions, "[G]oto [D]efinition")
		map("gri", builtin.lsp_implementations, "[G]oto [I]mplementation")
		map("grt", builtin.lsp_type_definitions, "[G]oto [T]ype Definition")
		map("gW", builtin.lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
		map("gO", builtin.lsp_document_symbols, "Open Document Symbols")
		map("K", vim.lsp.buf.hover, "Hover")
		map("gK", vim.lsp.buf.signature_help, "Signature Help")

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method("textDocument/inlayHint", event.buf) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "[T]oggle Inlay [H]ints")
			client.server_capabilities.semanticTokensProvider = nil
		end
	end,
})
vim.diagnostic.config({
	float = { border = "single", source = "if_many" },
	underline = false,
	signs = false,
})
vim.opt.statusline = table.concat({
	"%<%f %h%w%m%r ",
	"%{% v:lua.require('vim._core.util').term_exitcode() %}",
	"%=",
	"%{% luaeval('(package.loaded[''vim.ui''] and vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin or -1) and vim.ui.progress_status()) or '''' ')%}",
	"%{% &showcmdloc == 'statusline' ? '%-10.S ' : '' %}",
	"%{% exists('b:keymap_name') ? '<'..b:keymap_name..'> ' : '' %}",
	"%{% &busy > 0 ? '◐ ' : '' %}",
	"%{% &ruler ? (&rulerformat == '' ? '%-14.(%l,%c%V%) %P' : &rulerformat) : '' %}",
})
local servers = {
	clangd = {},
	dockerls = {},
	sqlls = {},
	jsonls = {},
	yamlls = {},
	basedpyright = {},
	rust_analyzer = {},
	neocmake = {},
	lua_ls = {},
}
for name, server in pairs(servers) do
	vim.lsp.config(name, server)
	vim.lsp.enable(name)
end

-- debugger
vim.pack.add({
	gh("mason-org/mason.nvim"),
	gh("nvim-lua/plenary.nvim"),
	gh("rcarriga/nvim-dap-ui"),
	gh("theHamsta/nvim-dap-virtual-text"),
	gh("nvim-neotest/nvim-nio"),
	gh("mfussenegger/nvim-dap"),
	gh("rcarriga/nvim-dap-ui"),
})
require("mason").setup({})
local dap = require("dap")
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
