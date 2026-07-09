vim.wo.number = true
vim.wo.relativenumber = true
vim.g.clipboard = {
	name = "osc52",
	copy = {
		["+"] = require("vim.ui.clipboard.osc52").copy("+"),
		["*"] = require("vim.ui.clipboard.osc52").copy("*"),
	},
	paste = {
		["+"] = require("vim.ui.clipboard.osc52").paste("+"),
		["*"] = require("vim.ui.clipboard.osc52").paste("*"),
	},
}
vim.o.wrap = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 0
vim.o.expandtab = false
vim.o.scrolloff = 4
vim.o.sidescrolloff = 8
vim.opt.termguicolors = true
vim.o.swapfile = false
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fillchars:append({ eob = " " })

vim.opt.showmode = false
vim.o.splitbelow = true
vim.o.splitright = true

vim.o.mouse = ""

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.opt.foldlevel = 99

vim.o.list = true
-- vim.opt.listchars = { lead = '·', tab = '|·' }
vim.opt.listchars = {
	tab = "▸ ",
	trail = "·",
	extends = "❯",
	precedes = "❮",
	nbsp = "␣",
}
vim.o.cmdheight = 0

-- performance options
vim.opt.synmaxcol = 240
vim.opt.updatetime = 200
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000
vim.opt.shortmess:append("I")
