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
vim.o.synmaxcol = 240
vim.o.updatetime = 200
vim.o.redrawtime = 10000
vim.o.maxmempattern = 20000
vim.opt.listchars = {
	tab = "▸ ",
	trail = "·",
	extends = "❯",
	precedes = "❮",
	nbsp = "␣",
}
vim.o.cmdheight = 0

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

-- plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

enabled_plugins = {
	"colorscheme",
	"editor",
	"telescope",
	"neotree",
	"formatter",
	"lsp",
	"debugger",
	"ai",
}

local colorscheme = {
	"rebelot/kanagawa.nvim",
	priority = 1000,
	lazy = false,
	config = function()
		require("kanagawa").setup({
			compile = false, -- enable compiling the colorscheme
			undercurl = true, -- enable undercurls
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			typeStyle = {},
			transparent = true, -- do not set background color
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			terminalColors = true, -- define vim.g.terminal_color_{0,17}
			colors = {
				palette = {},
				theme = {
					wave = {},
					lotus = {},
					dragon = {},
					all = {
						ui = {
							bg_gutter = "none",
						},
					},
				},
			},
			overrides = function(colors) -- add/modify highlights
				local theme = colors.theme
				return {
					TelescopeNormal = { bg = "NONE" },
					TelescopeBorder = { bg = "NONE" },
					TelescopePromptNormal = { bg = "NONE" },
					TelescopePromptBorder = { bg = "NONE" },
					TelescopeResultsNormal = { bg = "NONE" },
					TelescopeResultsBorder = { bg = "NONE" },
					TelescopePreviewNormal = { bg = "NONE" },
					TelescopePreviewBorder = { bg = "NONE" },
					TelescopeTitle = { fg = theme.ui.special, bg = "NONE", bold = true },
				}
			end,
			theme = "wave",
			background = {
				dark = "wave",
				light = "lotus",
			},
		})

		vim.cmd("colorscheme kanagawa")
	end,
}

local editor = {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		opts = {},
	},
	{
		"tpope/vim-fugitive",
	},
}

local telescope = {
	"nvim-telescope/telescope.nvim",
	tag = "v0.2.0",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
	},
	config = function()
		pickers = {
			find_files = {
				file_ignore_patterns = { "node_modules", ".git", ".venv", "build" },
				hidden = true,
			},
			live_grep = {
				file_ignore_patterns = { "node_modules", ".git", ".venv" },
				additional_args = function(_)
					return { "--hidden" }
				end,
			},
		}
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", ";f", builtin.find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", ";r", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", ";l", builtin.current_buffer_fuzzy_find, { desc = "search in current buffer" })
		vim.keymap.set("n", ";b", builtin.buffers, { desc = "[S]earch [B]uffers" })
		vim.keymap.set({ "n" }, ";c", function()
			vim.cmd("e " .. vim.fn.stdpath("config") .. "/init.lua")
		end)
	end,
}

local neotree = {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	lazy = false, -- neo-tree will lazily load itself
	config = function()
		require("neo-tree").setup({
			sources = { "filesystem" },
			close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
			-- popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = false,
			open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
			default_component_configs = {
				indent = {
					indent_marker = " ",
					last_indent_marker = " ",
					expander_collapsed = ">",
					expander_expanded = "v",
				},
				icon = {
					use_filtered_colors = true,
					provider = function() end,
					highlight = "NeoTreeFileIcon",
					folder_closed = "▸",
					folder_open = "▾",
					folder_empty = "▹",
					folder_empty_open = "▿",
					default = "·",
				},
				git_status = {
					symbols = {
						-- Change type
						added = "",
						modified = "",
						deleted = "x",
						renamed = "R",
						-- Status type
						untracked = "?",
						ignored = "i",
						unstaged = "!",
						staged = "*",
						conflict = "C",
					},
				},
				file_size = {
					enabled = true,
					width = 12, -- width of the column
					required_width = 64, -- min width of window required to show this column
				},
				type = {
					enabled = true,
					width = 10, -- width of the column
					required_width = 122, -- min width of window required to show this column
				},
				last_modified = {
					enabled = true,
					width = 20, -- width of the column
					required_width = 88, -- min width of window required to show this column
				},
				created = {
					enabled = true,
					width = 20, -- width of the column
					required_width = 110, -- min width of window required to show this column
				},
				symlink_target = {
					enabled = false,
				},
			},
			window = {
				position = "current",
			},
		})

		vim.keymap.set("n", "<leader>e", "<Cmd>Neotree toggle<CR>")
		vim.api.nvim_create_user_command("Reveal", function(opts)
			vim.cmd("Neotree position=current dir=" .. opts.args)
		end, {
			nargs = 1,
			complete = "file",
			desc = "Open neotree at path",
		})
	end,
}

local formatter = {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"stylua",
				"prettier",
				"shfmt",
				"isort",
				"clang-format",
			},
		},
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
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
		},
	},
}

local lsp = {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"mason-org/mason.nvim",
			opts = {},
		},
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
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
				map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
				map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
				-- Jump to the type of the word under your cursor.
				--  Useful when you're not sure what type a variable is and you want to see
				--  the definition of its *type*, not where it was *defined*.
				map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
				map("K", function()
					return vim.lsp.buf.hover()
				end, "Hover")
				map("gK", function()
					return vim.lsp.buf.signature_help()
				end, "Signature Help")

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client then
					client.server_capabilities.semanticTokensProvider = nil
				end
				if client and client:supports_method("textDocument/inlayHint", event.buf) then
					map("<leader>th", function()
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
					Lua = {},
				},
			},
		}

		-- Ensure the servers and tools above are installed
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			-- add other tools here that mason should install
		})

		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		for name, server in pairs(servers) do
			vim.lsp.config(name, server)
			vim.lsp.enable(name)
		end
	end,
}

local debugger = {
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
			local cpp_launch_config = {
				name = "launch exe",
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

			local cpp_attach_config = {
				name = "attach to proc",
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
			if is_macos then
				cpp_launch_config.type = "codelldb"
				cpp_attach_config.type = "codelldb"
				cpp_attach_config.pid = utils.pick_process
			else
				cpp_launch_config.type = "cppdbg"
				cpp_attach_config.type = "cppdbg"
				cpp_attach_config.MIMode = "gdb"
				cpp_attach_config.processId = function()
					return utils.pick_process()
				end
				cpp_attach_config.program = function()
					local pid = utils.pick_process()
					if not pid then
						return nil
					end
					return vim.fn.resolve("/proc/" .. pid .. "/exe")
				end
				-- if attach fails:
				-- sudo sysctl kernel.yama.ptrace_scope=0
			end
			local python_launch_current_file = {
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

			local python_launch_file = {
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

			dap.configurations.cpp = { cpp_launch_config, cpp_attach_config }
			dap.configurations.c = { cpp_launch_config, cpp_attach_config }
			dap.configurations.python = { python_launch_current_file, python_launch_file }

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

local ai = {
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false,
		opts = {
			instructions_file = "instructions.md",
			provider = "codex",
			selection = {
				hint_display = "none",
			},
			selector = {
				provider = "telescope",
			},
			windows = {
				position = "right",
				width = 45,
				sidebar_header = { enabled = false },
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
}

local plugin_map = {
	["colorscheme"] = colorscheme,
	["editor"] = editor,
	["telescope"] = telescope,
	["neotree"] = neotree,
	["formatter"] = formatter,
	["lsp"] = lsp,
	["debugger"] = debugger,
	["ai"] = ai,
}
local active_plugins = {}
for _, plugin in ipairs(enabled_plugins) do
	table.insert(active_plugins, plugin_map[plugin])
end

require("lazy").setup(active_plugins, {
	ui = {
		icons = {
			cmd = "▸ ",
			config = "◆ ",
			debug = "◉ ",
			event = "⚑ ",
			favorite = "★ ",
			ft = "◈ ",
			init = "▹ ",
			import = "← ",
			keys = "⌨ ",
			lazy = "⏻ ",
			loaded = "●",
			not_loaded = "○",
			plugin = "▣ ",
			runtime = "▤ ",
			require = "→ ",
			source = "§ ",
			start = "▶ ",
			task = "▾ ",
			list = { "●", "▸", "★", "○" },
		},
	},
})
