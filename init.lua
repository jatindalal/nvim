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

local colorscheme = {}
colorscheme.palette = {
	bg = "#0a0a0a", -- base background (near-black)
	bg_dim = "#050403", -- statusline/inactive
	bg_float = "#120e0a", -- popups, floats
	bg_visual = "#2e2318", -- visual selection
	bg_line = "#161109", -- cursorline

	fg = "#e6d9c3", -- primary text
	fg_dim = "#a8967d", -- secondary text (params, punctuation)
	comment = "#7a6a58", -- comments, line numbers

	border = "#3d3226",

	brown = "#b0703f", -- keywords, control flow (was purple)
	brown_dim = "#8a5a35",
	brown_bright = "#c68752",
	green = "#8fa668", -- functions, identifiers (was purple accent 2)
	green_dim = "#748a52",
	green_bright = "#a3bd7e",
	tan = "#d4a655", -- constants, numbers
	tan_bright = "#e0b76a",
	clay = "#c4634a", -- errors, deletions
	clay_bright = "#d97a61",
	amber = "#d0904a", -- warnings, types
	teal = "#6b9a8a", -- strings
	teal_bright = "#82b5a5",
	dust_blue = "#469ca0", -- info, links
	dust_blue_bright = "#5cb3b7",

	red = "#c4634a",
	green2 = "#7c9a5c", -- git add
	yellow = "#d4a655",
	blue = "#469ca0",
}

function colorscheme.setup()
	local p = colorscheme.palette
	-- vim.cmd("highlight clear")
	-- if vim.fn.exists("syntax_on") then
	-- 	vim.cmd("syntax reset")
	-- end
	vim.o.background = "dark"
	vim.g.colors_name = "warmdesert"

	local hl = function(group, opts)
		vim.api.nvim_set_hl(0, group, opts)
	end

	-- Editor UI
	hl("Normal", { fg = p.fg, bg = p.bg })
	hl("NormalFloat", { fg = p.fg, bg = p.bg_float })
	hl("FloatBorder", { fg = p.border, bg = p.bg_float })
	hl("Cursor", { fg = p.bg, bg = p.fg })
	hl("CursorLine", { bg = p.bg_line })
	hl("CursorLineNr", { fg = p.tan, bold = true })
	hl("LineNr", { fg = p.comment })
	hl("SignColumn", { bg = p.bg })
	hl("ColorColumn", { bg = p.bg_line })
	hl("VertSplit", { fg = p.border })
	hl("WinSeparator", { fg = p.border })
	hl("Visual", { bg = p.bg_visual })
	hl("VisualNOS", { bg = p.bg_visual })
	hl("Search", { fg = p.bg, bg = p.tan })
	hl("IncSearch", { fg = p.bg, bg = p.clay })
	hl("Pmenu", { fg = p.fg, bg = p.bg_float })
	hl("PmenuSel", { fg = p.bg, bg = p.brown })
	hl("PmenuSbar", { bg = p.bg_float })
	hl("PmenuThumb", { bg = p.brown_dim })
	hl("StatusLine", { fg = p.fg, bg = p.bg_dim })
	hl("StatusLineNC", { fg = p.comment, bg = p.bg_dim })
	hl("TabLine", { fg = p.brown_bright, bg = p.bg_dim })
	hl("TabLineSel", { fg = p.bg, bg = p.brown_bright, bold = true })
	hl("TabLineFill", { bg = p.bg })
	hl("Directory", { fg = p.green })
	hl("Title", { fg = p.brown, bold = true })
	hl("NonText", { fg = p.border })
	hl("Whitespace", { fg = p.border })
	hl("MatchParen", { fg = p.tan, bold = true, underline = true })
	hl("WinBar", { fg = p.fg_dim, bg = p.bg })

	-- Syntax
	hl("Comment", { fg = p.comment })
	hl("Constant", { fg = p.tan })
	hl("String", { fg = p.green })
	hl("Character", { fg = p.green })
	hl("Number", { fg = p.tan })
	hl("Boolean", { fg = p.tan, bold = true })
	hl("Identifier", { fg = p.fg })
	hl("Function", { fg = p.red, bold = true })
	hl("Statement", { fg = p.brown, bold = true })
	hl("Conditional", { fg = p.brown, italic = true })
	hl("Repeat", { fg = p.brown, italic = true })
	hl("Keyword", { fg = p.brown, italic = true })
	hl("Operator", { fg = p.teal })
	hl("PreProc", { fg = p.teal })
	hl("Type", { fg = p.amber })
	hl("Structure", { fg = p.amber })
	hl("Special", { fg = p.clay })
	hl("Underlined", { fg = p.dust_blue, underline = true })
	hl("Error", { fg = p.clay, bold = true })
	hl("Todo", { fg = p.bg, bg = p.tan, bold = true })
	hl("Delimiter", { fg = p.fg_dim })

	hl("@variable", { fg = p.fg })
	hl("@variable.builtin", { fg = p.clay, italic = true })
	hl("@variable.parameter", { fg = p.teal, italic = true })
	hl("@constant", { link = "Constant" })
	hl("@constant.builtin", { fg = p.tan, bold = true })
	hl("@string", { link = "String" })
	hl("@string.escape", { fg = p.teal, bold = true })
	hl("@function", { link = "Function" })
	hl("@function.builtin", { fg = p.dust_blue, italic = true })
	hl("@method", { link = "Function" })
	hl("@keyword", { link = "Keyword" })
	hl("@keyword.function", { fg = p.brown })
	hl("@keyword.return", { fg = p.brown, italic = true })
	hl("@keyword.operator", { fg = p.teal })
	hl("@type", { link = "Type" })
	hl("@type.builtin", { fg = p.amber, italic = true })
	hl("@property", { fg = p.teal })
	hl("@field", { fg = p.teal })
	hl("@tag", { fg = p.clay })
	hl("@tag.attribute", { fg = p.amber, italic = true })
	hl("@punctuation.bracket", { fg = p.fg_dim })
	hl("@punctuation.delimiter", { fg = p.fg_dim })
	hl("@comment", { link = "Comment" })
	hl("@operator", { link = "Operator" })
	hl("@boolean", { link = "Boolean" })
	hl("@number", { fg = p.tan })

	-- LSP / diagnostics
	hl("DiagnosticError", { fg = p.clay })
	hl("DiagnosticWarn", { fg = p.amber })
	hl("DiagnosticInfo", { fg = p.dust_blue })
	hl("DiagnosticHint", { fg = p.green })
	hl("DiagnosticUnderlineError", { undercurl = true, sp = p.clay })
	hl("DiagnosticUnderlineWarn", { undercurl = true, sp = p.amber })
	hl("DiagnosticUnderlineInfo", { undercurl = true, sp = p.dust_blue })
	hl("DiagnosticUnderlineHint", { undercurl = true, sp = p.green })
	hl("LspReferenceText", { bg = p.bg_line })
	hl("LspReferenceRead", { bg = p.bg_line })
	hl("LspReferenceWrite", { bg = p.bg_visual })

	-- Git
	hl("DiffAdd", { fg = p.green2, bg = p.bg_line })
	hl("DiffChange", { fg = p.amber, bg = p.bg_line })
	hl("DiffDelete", { fg = p.clay, bg = p.bg_line })
	hl("DiffText", { fg = p.tan, bg = p.bg_visual })
	hl("GitSignsAdd", { fg = p.green2 })
	hl("GitSignsChange", { fg = p.amber })
	hl("GitSignsDelete", { fg = p.clay })

	-- Terminal colors (:terminal, fzf, lazygit, etc.)
	vim.g.terminal_color_0 = p.bg_dim
	vim.g.terminal_color_1 = p.clay
	vim.g.terminal_color_2 = p.green
	vim.g.terminal_color_3 = p.tan
	vim.g.terminal_color_4 = p.dust_blue
	vim.g.terminal_color_5 = p.brown
	vim.g.terminal_color_6 = p.teal
	vim.g.terminal_color_7 = p.fg_dim
	vim.g.terminal_color_8 = p.comment
	vim.g.terminal_color_9 = p.clay_bright
	vim.g.terminal_color_10 = p.green_bright
	vim.g.terminal_color_11 = p.tan_bright
	vim.g.terminal_color_12 = p.dust_blue_bright
	vim.g.terminal_color_13 = p.brown_bright
	vim.g.terminal_color_14 = p.teal_bright
	vim.g.terminal_color_15 = p.fg

	-- for plugins that read a background/foreground pair off terminal colors
	vim.g.terminal_color_background = p.bg
	vim.g.terminal_color_foreground = p.fg
end
_G.palette = colorscheme.palette
colorscheme.setup()

function _G.TabLine()
	local s = ""

	for i = 1, vim.fn.tabpagenr("$") do
		local winnr = vim.fn.tabpagewinnr(i)
		local bufnr = vim.fn.tabpagebuflist(i)[winnr]

		local name = vim.fn.bufname(bufnr)
		if name == "" then
			name = "[No Name]"
		else
			name = vim.fn.fnamemodify(name, ":t") -- filename only
		end

		local modified = vim.bo[bufnr].modified and " ●" or ""

		if i == vim.fn.tabpagenr() then
			s = s .. "%#TabLineSel#"
		else
			s = s .. "%#TabLine#"
		end

		-- Mouse click target
		s = s .. "%" .. i .. "T"

		-- Label
		s = s .. " " .. i .. " " .. name .. modified .. " "
	end

	s = s .. "%#TabLineFill#%T"
	return s
end
vim.o.tabline = "%!v:lua.TabLine()"
vim.o.showtabline = 2

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
	"editor",
	"telescope",
	"neotree",
	"formatter",
	"lsp",
	"debugger",
	"ai",
}

local plugins = {}

plugins.editor = {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		opts = {},
	},
	{
		"tpope/vim-fugitive",
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			local theme = require("lualine.themes.auto")

			require("lualine").setup({
				options = {
					icons_enabled = false,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = " ", right = " " },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					always_show_tabline = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
						refresh_time = 16, -- ~60fps
						events = {
							"WinEnter",
							"BufEnter",
							"BufWritePost",
							"SessionLoadPost",
							"FileChangedShellPost",
							"VimResized",
							"Filetype",
							"CursorMoved",
							"CursorMovedI",
							"ModeChanged",
						},
					},
				},
				sections = {
					lualine_a = {
						{
							"mode",
							fmt = function(str)
								return str:sub(1, 1)
							end,
						},
					},
					lualine_b = { "branch", "diff" },
					lualine_c = {},
					lualine_x = { "filename", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				-- tabline = {
				-- 	lualine_a = {
				-- 		{
				-- 			"tabs",
				-- 			mode = 2,
				-- 			max_length = vim.o.columns,
				-- 			show_modified_status = true,
				-- 			symbols = {
				-- 				modified = " ●",
				-- 			},
				-- 			fmt = function(name, context)
				-- 				return name
				-- 			end,
				-- 			tabs_color = {
				-- 				active = { bg = _G.palette.brown_bright, fg = _G.palette.bg_dim, gui = "bold" },
				-- 				inactive = { bg = _G.palette.bg, fg = _G.palette.fg_dim },
				-- 			},
				-- 		},
				-- 	},
				-- },
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			})
		end,
	},
}

plugins.telescope = {
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

plugins.neotree = {
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
				position = "right",
				width = function()
					return math.floor(vim.o.columns * 0.4)
				end,
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

plugins.formatter = {
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

plugins.lsp = {
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
				-- if client then
				-- 	client.server_capabilities.semanticTokensProvider = nil
				-- end
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
			basedpyright = {},
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

plugins.debugger = {
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

plugins.ai = {
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

local active_plugins = {}
for _, plugin in ipairs(enabled_plugins) do
	table.insert(active_plugins, plugins[plugin])
end

require("lazy").setup(active_plugins)
