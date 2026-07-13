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
						TabLineFill = { bg = "NONE" },
						TabLine = { bg = "NONE" },
						TabLineSel = { bg = "NONE" },
						StatusLine = { bg = "NONE" },
						StatusLineNC = { bg = "NONE" },
						NormalFloat = { bg = "none" },
						FloatBorder = { bg = "none" },
						FloatTitle = { bg = "none" },
						TelescopeTitle = { fg = theme.ui.special, bold = true },
						TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = "NONE" },
						TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = "NONE" },
						TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = "NONE" },
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
