require("core.options")
require("core.keymaps")
require("core.autocmds")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	require("plugins.colorscheme"),
	require("plugins.editor"),
	require("plugins.neotree"),
	require("plugins.telescope"),
	require("plugins.formatter"),
	-- require("plugins.debug"),
	require("plugins.lsp"),
}, {
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
