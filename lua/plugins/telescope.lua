return {
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
		vim.keymap.set("n", ";t", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", ";f", builtin.find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", ";r", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", ";b", builtin.buffers, { desc = "[S]earch [B]uffers" })
		vim.keymap.set("n", ";;", builtin.current_buffer_fuzzy_find, { desc = "search in current buffer"})
		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", ";c", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })
	end,
}
