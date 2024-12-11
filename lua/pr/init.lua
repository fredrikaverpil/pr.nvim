PRLIB = require("pr.lib")

---@class PR
local M = {}

---@class PR.Config
---@field token string|fun():string|nil The GitHub token for private repositories (optional)

--- Setup the PR plugin.
---@param opts? PR.Config
function M.setup(opts)
	opts = opts or {}
	M.opts = opts

	vim.api.nvim_create_user_command("PRView", function(_)
		require("pr").view()
	end, {
		desc = "Open pull request in browser",
		nargs = "?", -- Optional arguments
	})
end

--- View the pull request in the browser.
function M.view()
	local sha = PRLIB.get_git_commit_sha()
	if not sha then
		vim.notify("could not get git commit SHA", vim.log.levels.WARNING)
		return
	end

	local remote_url = PRLIB.get_git_remote_url()
	if not remote_url then
		vim.notify("could not get git remote URL", vim.log.levels.WARNING)
		return
	end

	if remote_url:match("^git@") then
		remote_url = PRLIB.transform_ssh_to_https(remote_url)
	end

	-- hostname is meant to decide which strategy/API to use.
	local hostname = remote_url:match("https?://([^/]+)")
	if not hostname then
		vim.notify("could not get hostname from remote URL: " .. vim.inspect(remote_url), vim.log.levels.WARNING)
		return
	end

	local pr_url
	if hostname == "github.com" then
		pr_url = require("pr.github").get_pr_url(remote_url, sha, M.opts.token)
	else
		vim.notify("unsupported hostname: " .. hostname, vim.log.levels.WARNING)
	end

	if pr_url then
		PRLIB.open_in_browser(pr_url)
	end
end

return M
