M = {}

--- Get the git commit SHA from where the cursor is at.
---@return string|nil The git commit SHA or nil if not found
function M.get_git_commit_sha()
	local cursor_at_line = vim.api.nvim_win_get_cursor(0)[1]
	-- use git rev-parse to determine git root
	local git_root_cmd = { "git", "-C", vim.fn.expand("%:p:h"), "rev-parse", "--show-toplevel" }
	local git_root_obj = vim.system(git_root_cmd, { text = true }):wait()
	if git_root_obj.code ~= 0 then
		return nil
	end
	local git_root = vim.trim(git_root_obj.stdout)
	-- run blame based on the git root found
	local blame_cmd = {
		"git",
		"-C",
		git_root,
		"blame",
		"-l",
		"-L",
		cursor_at_line .. "," .. cursor_at_line,
		"-s",
		vim.fn.expand("%:p"),
	}
	local blame_obj = vim.system(blame_cmd, { text = true }):wait()
	if blame_obj.code == 0 then
		return vim.split(blame_obj.stdout, " ")[1]
	end
end

--- Get the remote origin URL of the git repository.
---@return string|nil The remote origin URL or nil if not found.
function M.get_git_remote_url()
	-- example command: $ git remote get-url origin
	local cmd = { "git", "remote", "get-url", "origin" }
	local obj = vim.system(cmd, { text = true }):wait()
	if obj.code == 0 then
		local url = vim.trim(obj.stdout)
		return url
	end
end

--- Transform git+ssh URL to https URL
---@param url string
---@return string
function M.transform_ssh_to_https(url)
	local user_repo = url:match("git@[^:]+:(.+)")
	if user_repo then
		return "https://github.com/" .. user_repo
	end
	return url
end

--- Open the PR URL in the browser.
---@param url string The URL to open
function M.open_in_browser(url)
	local cmd
	if vim.fn.has("win32") == 1 then
		cmd = { "cmd.exe", "/c", "start", url }
	elseif vim.fn.has("macunix") == 1 then
		cmd = { "open", url }
	else
		cmd = { "xdg-open", url }
	end

	local obj = vim.system(cmd, { text = true }):wait()
	if obj.code ~= 0 then
		vim.notify("Failed to open URL: " .. url .. "\n" .. vim.inspect(obj.stderr), vim.log.levels.ERROR)
	end
end

return M
