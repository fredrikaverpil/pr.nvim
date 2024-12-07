---@class PR
local M = {}

function M.setup(_)
	vim.api.nvim_create_user_command("PROpen", function(_)
		require("pr").open()
	end, {
		desc = "Open pull request in browser",
		nargs = "?", -- Optional arguments
	})
end

--- Get the git commit SHA from where the cursor is at.
---@return string|nil The git commit SHA or nil if not found
local function get_git_commit_sha()
	local cursor_at_line = vim.api.nvim_win_get_cursor(0)[1]
	-- example command: $ git blame -l -L 2,2 -s README.md
	local cmd = { "git", "blame", "-l", "-L", cursor_at_line .. "," .. cursor_at_line, "-s", vim.fn.expand("%") }
	local obj = vim.system(cmd, { text = true }):wait()
	if obj.code == 0 then
		-- the first word is the commit sha
		local sha = vim.split(obj.stdout, " ")[1]
		return sha
	end
end

--- Get the remote origin URL of the git repository.
---@return string|nil The remote origin URL or nil if not found.
local function get_git_remote_url()
	-- example command: $ git remote get-url origin
	local cmd = { "git", "remote", "get-url", "origin" }
	local obj = vim.system(cmd, { text = true }):wait()
	if obj.code == 0 then
		local url = vim.trim(obj.stdout)
		return url
	end
end

--- Open the PR URL in the browser.
---@param url string The URL to open
local function open_in_browser(url)
	local cmd
	if vim.fn.has("win32") == 1 then
		cmd = { "cmd.exe", "/c", "start", url }
	elseif vim.fn.has("macunix") == 1 then
		cmd = { "open", url }
	else
		cmd = { "xdg-open", url }
	end

	vim.fn.jobstart(cmd, {
		detach = true,
		on_stderr = function(_, data)
			if data then
				print("Error opening URL: " .. vim.inspect(data))
			end
		end,
	})
end

--- Main function
--- Get the PRs for the current git commit SHA.
--- Based on the hostname of the remote origin URL, it will use the corresponding API.
function M.open()
	local sha = get_git_commit_sha()
	if not sha then
		return
	end

	local remote_url = get_git_remote_url()
	if not remote_url then
		return
	end

	local hostname = remote_url:match("https?://([^/]+)")
	if not hostname then
		return
	end

	local pr_url
	if hostname == "github.com" then
		pr_url = require("pr.github").get_pr_url(remote_url, sha)
	end

	if pr_url then
		open_in_browser(pr_url)
	end
end

return M
