vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-- Resize
vim.keymap.set("n", "<A-h>", ":vertical resize +5<Return>", opts)
vim.keymap.set("n", "<A-l>", ":vertical resize -5<Return>", opts)
vim.keymap.set("n", "<A-k>", ":horizontal resize +5<Return>", opts)
vim.keymap.set("n", "<A-j>", ":horizontal resize -5<Return>", opts)

-- Window management
vim.keymap.set("n", "sv", "<C-w>v", opts) -- split window vertically
vim.keymap.set("n", "ss", "<C-w>s", opts) -- split window horizontally
vim.keymap.set("n", "se", "<C-w>=", opts) -- make split windows equal width & height
vim.keymap.set("n", "sx", ":close<CR>", opts) -- close current split window

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-- Tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab
vim.keymap.set("n", "<s-h>", ":tabprev<CR>", opts) --  go to next tab
vim.keymap.set("n", "<s-l>", ":tabnext<CR>", opts) --  go to previous tab

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- remap ctrl-c to escape in insert mode
vim.keymap.set("i", "<C-c>", "<Esc>", opts)

-- use escape to exit terminal mode
vim.keymap.set("t", "<Esc>", function()
	local name = vim.api.nvim_buf_get_name(0)
	if name:match("lazygit") then
		return "<Esc>"
	end
	return "<C-\\><C-N>"
end, { expr = true })

vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)

-- clipbard keybinds
vim.keymap.set("n", "<Leader>y", '"+y', opts)

vim.keymap.set("v", "<Leader>y", '"+y', opts)

vim.keymap.set("n", "<Leader>p", '"+p', opts)

vim.keymap.set("v", "<Leader>p", '"+p', opts)

-- inlay hints
vim.keymap.set("n", "<leader>ih", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

-- lazygit
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

-- terminal
vim.keymap.set({ "n", "i" }, "<C-t>", function()
	vim.cmd.tabnew()
	vim.cmd("terminal")
	local buf = vim.api.nvim_get_current_buf()
	local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	vim.api.nvim_buf_set_name(buf, "term:" .. cwd)
	vim.cmd.startinsert()
end, { desc = "Open terminal tab" })
