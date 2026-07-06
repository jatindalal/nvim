local dap = require("dap")
local utils = require("dap.utils")
local mason_path = vim.fn.stdpath("data") .. "/mason"
local is_macos = vim.loop.os_uname().sysname == "Darwin"

local function get_active_python()
	-- 1. Activated virtualenv (POSIX / macOS / Linux)
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

-- Configure Adapters
if is_macos then
	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = mason_path .. "/bin/codelldb",
			args = { "--port", "${port}" },
		},
	}
else
	dap.adapters.cppdbg = {
		id = "cppdbg",
		type = "executable",
		command = mason_path .. "/bin/OpenDebugAD7",
	}
end

-- Configurations
local launch_config = {
	name = "Launch Executable",
	request = "launch",
	program = function()
		return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
	end,
	cwd = function()
		return vim.fn.input("cwd: ", vim.fn.getcwd() .. "/", "file")
	end,
	stopOnEntry = false,
	runInTerminal = true,
	args = function()
		-- Prompt the user for script arguments
		local input = vim.fn.input("Args: ", "", "file") -- e.g. type: arg1 arg2
		return vim.split(input, "%s+") -- split on spaces into a Lua table
	end,
	setupCommands = {
		{
			text = "-enable-pretty-printing",
			description = "enable pretty printing",
			ignoreFailures = false,
		},
	},
}

local attach_config = {
	name = "Attach to Process",
	request = "attach",
	cwd = "${workspaceFolder}",
	setupCommands = {
		{
			text = "-enable-pretty-printing",
			description = "enable pretty printing",
			ignoreFailures = false,
		},
	},
}

if is_macos then
	launch_config.type = "codelldb"
	attach_config.type = "codelldb"
	attach_config.pid = utils.pick_process
else
	launch_config.type = "cppdbg"
	attach_config.type = "cppdbg"
	attach_config.MIMode = "gdb"
	attach_config.processId = function()
		return utils.pick_process()
	end
	attach_config.program = function()
		local pid = utils.pick_process()
		if not pid then
			return nil
		end
		return vim.fn.resolve("/proc/" .. pid .. "/exe")
	end
	-- if attach fails:
	-- sudo sysctl kernel.yama.ptrace_scope=0
end

dap.configurations.cpp = { launch_config, attach_config }
dap.configurations.c = { launch_config, attach_config }
