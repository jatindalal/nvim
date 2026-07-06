vim.api.nvim_create_user_command("ConfigSync", function()
	local config_dir = vim.fn.stdpath("config")

	local function run(cmd)
		local result = vim.fn.system("git -C " .. config_dir .. " " .. cmd .. " 2>&1")
		return result, vim.v.shell_error == 0
	end

	local stashed = false
	local stash_out, stash_ok = run("stash")
	if not stash_ok then
		vim.notify("Stash failed:\n" .. stash_out, vim.log.levels.ERROR)
		return
	end
	stashed = not stash_out:match("No local changes to save")

	local pull_out, pull_ok = run("pull --rebase")
	if not pull_ok then
		vim.notify("Pull failed:\n" .. pull_out, vim.log.levels.ERROR)
		if stashed then
			run("stash pop")
		end
		return
	end

	if stashed then
		local pop_out, pop_ok = run("stash pop")
		if not pop_ok then
			vim.notify("Stash pop failed (conflict):\n" .. pop_out, vim.log.levels.WARN)
			return
		end
	end

	vim.notify("Config synced" .. (stashed and " (local changes preserved)" or ""), vim.log.levels.INFO)
end, {})

local function augroup(name)
	return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		(vim.hl or vim.highlight).on_yank()
	end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})
