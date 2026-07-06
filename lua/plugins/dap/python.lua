local dap = require("dap")
local mason_path = vim.fn.stdpath("data") .. "/mason"

local function get_active_python()
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

dap.adapters.python = {
	type = "executable",
	command = mason_path .. "/packages/debugpy/venv/bin/python",
	args = {
		"-m",
		"debugpy.adapter",
	},
}

local launch_current_file = {
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

local launch_file = {
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

local attach_config = {
	type = "python",
	request = "attach",
	name = "Attach Remote",
	connect = function()
		local host = vim.fn.input("Host [127.0.0.1]: ")
		host = host ~= "" and host or "127.0.0.1"

		local port = tonumber(vim.fn.input("Port: "))

		return {
			host = host,
			port = port,
		}
	end,

	mode = "remote",
	cwd = "${workspaceFolder}",
	python = function()
		return vim.fn.input("python: ", get_active_python(), "file")
	end,
}

dap.configurations.python = { launch_current_file, launch_file, attach_config }
