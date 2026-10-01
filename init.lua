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
vim.keymap.set({ "n" }, "<leader>e", function()
    if vim.bo.filetype == "netrw" then
        if netrw_prev_buf and vim.api.nvim_buf_is_valid(netrw_prev_buf) then
            vim.api.nvim_win_set_buf(0, netrw_prev_buf)
        else
            vim.cmd.enew()
        end
        netrw_prev_buf = nil
    else
        netrw_prev_buf = vim.api.nvim_get_current_buf()
        vim.cmd.Explore()
    end

end)
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
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, {
	desc = "Diagnostics to location list",
})

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

local function find_files(pattern)
    if vim.fn.executable("fd") == 1 then
		files = vim.fn.systemlist({
			"fd",
			"--type", "f",
			"--hidden",
		})
    elseif vim.fn.executable("find") == 1 then
		files = vim.fn.systemlist({
			"find",
			".",
			"-type", "f",
		})
	else
		return {}
	end

	if vim.v.shell_error ~= 0 then
		return {}
	end

	return vim.fn.matchfuzzy(files, pattern)
end
vim.api.nvim_create_user_command("Find", function(opts)
	local function run(pattern)
		if not pattern or pattern == "" then
			return
		end

		local files = find_files(pattern)

		vim.fn.setqflist({}, " ", {
			title = "Find: " .. pattern,
			items = vim.tbl_map(function(file)
				return { filename = file }
			end, files),
		})

		vim.cmd("copen")
	end

	if opts.args ~= "" then
		run(opts.args)
	else
		vim.ui.input({ prompt = "Find: " }, run)
	end
end, {
	nargs = "?",
})

if vim.fn.executable("rg") == 1 then
	vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
	vim.opt.grepformat = "%f:%l:%c:%m"
elseif vim.fn.executable("grep") == 1 then
	vim.opt.grepprg = "grep -nH -r -I"
	vim.opt.grepformat = "%f:%l:%m"
end
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

vim.cmd.colorscheme('retrobox')

vim.keymap.set("n", ";c", function() vim.cmd("e " .. vim.fn.stdpath("config") .. "/init.lua") end)
vim.keymap.set("n", ";f", function() vim.cmd("Find ") end)
vim.keymap.set("n", ";r", function() vim.cmd("Grep ") end)

--plugins

local function gh(repo)
	return "https://github.com/" .. repo
end
vim.pack.add({ gh("skylarmb/torchlight.nvim") })
require('torchlight').setup({
    contrast = "stark",
})
local hl = vim.api.nvim_set_hl
hl(0, 'TabLineFill', { bg = "none" })
hl(0, 'TabLine', { bg = "none", fg="#979764" })
hl(0, 'TabLineSel', { bg = "none", fg="#c6aa77" })
hl(0, 'FloatBorder', { bg = "none", fg="#dcbb7e" })
hl(0, 'Folded', { bg = "none", fg="#979764" })
hl(0, 'StatusLine', { bg = "none", fg="#c6aa77" })
hl(0, 'StatusLineNC', { bg = "none", fg="#414035" })
hl(0, 'TelescopeBorder', { bg = "none", fg="#dcbb7e" })
vim.pack.add({
	gh("windwp/nvim-autopairs"),
	gh("tpope/vim-fugitive"),
})
require("nvim-autopairs").setup({})
