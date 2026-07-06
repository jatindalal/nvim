return {
	{
		"nvim-mini/mini.indentscope",
		opts = {
			draw = {
				delay = 0,
			},
			symbol = "┊",
		},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		opts = {},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			{
				"nvim-mini/mini.icons",
				config = function()
					require("mini.icons").setup({
						style = "ascii",
					})
				end,
			},
		},
		opts = {
			heading = {
				icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
			},

			bullet = {
				icons = { "-", "-", "-", "-" },
			},

			checkbox = {
				unchecked = { icon = "[ ] " },
				checked = { icon = "[x] " },
				custom = {
					todo = {
						raw = "[-]",
						rendered = "[-] ",
					},
				},
			},

			quote = {
				icon = "> ",
			},

			dash = {
				icon = "-",
			},
		},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
		},
	},
	{
		"tpope/vim-fugitive",
	},
}
