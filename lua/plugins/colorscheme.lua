return {
	{
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
						Normal = { bg = "NONE" },
						NormalNC = { bg = "NONE" },
						NormalFloat = { bg = "NONE" },
						SignColumn = { bg = "NONE" },
						EndOfBuffer = { bg = "NONE" },
						LineNr = { bg = "NONE" },
						CursorLineNr = { bg = "NONE" },
						NeoTreeCursorLine = { bg = "NONE", bold = true },
						CursorLine = { bg = "NONE" },
						ColorColumn = { bg = "NONE" },
						FoldColumn = { bg = "NONE" },
						Folded = { bg = "NONE" },
						WinSeparator = { bg = "NONE" },
						VertSplit = { bg = "NONE" },
						StatusLine = { bg = "NONE" },
						StatusLineNC = { bg = "NONE" },
						TabLine = { bg = "NONE" },
						TabLineFill = { bg = "NONE" },
						TabLineSel = { bg = "NONE" },
						Pmenu = { bg = "NONE" },
						PmenuSel = {},
						PmenuKind = { bg = "NONE" },
						PmenuKindSel = { bg = "NONE" },
						PmenuExtra = { bg = "NONE" },
						PmenuExtraSel = { bg = "NONE" },
						PmenuSbar = { bg = "NONE" },
						PmenuThumb = { bg = "NONE" },
						FloatBorder = { bg = "NONE" },
						FloatTitle = { bg = "NONE" },
						FloatFooter = { bg = "NONE" },
						NormalSB = { bg = "NONE" },
						NormalFloat = { bg = "NONE" },
						BlinkCmpMenuBorder = { bg = "NONE" },
						CmpCompletionBorder = { bg = "NONE" },
						FloatermBorder = { bg = "NONE" },
						NotifyBackground = { bg = "NONE" },
						TelescopeNormal = { bg = "NONE" },
						TelescopeBorder = { bg = "NONE" },
						TelescopePromptNormal = { bg = "NONE" },
						TelescopePromptBorder = { bg = "NONE" },
						TelescopeResultsNormal = { bg = "NONE" },
						TelescopeResultsBorder = { bg = "NONE" },
						TelescopePreviewNormal = { bg = "NONE" },
						TelescopePreviewBorder = { bg = "NONE" },
						TelescopeTitle = { fg = theme.ui.special, bg = "NONE", bold = true },
						MsgArea = { bg = "NONE" },
						MsgSeparator = { bg = "NONE" },
						QuickFixLine = { bg = "NONE" },
						WinBar = { bg = "NONE" },
						WinBarNC = { bg = "NONE" },
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
	},
}
