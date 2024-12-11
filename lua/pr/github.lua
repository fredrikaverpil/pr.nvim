local curl = require("plenary.curl")

local M = {}

--- Get the GitHub pull request URL for the given git remote and commit SHA.
---@param url string The remote URL, e.g. https://github.com/fredrikaverpil/neotest-golang.git
---@param sha string The commit SHA, e.g. 123abc
---@param token string|fun():string|nil The GitHub token for private repositories (optional)
function M.get_pr_url(url, sha, token)
	local owner_repo = string.match(url, "github.com/([^/]+/[^/]+)%.git")
	if not owner_repo then
		vim.notify("Failed to get owner/repo from URL: " .. url, vim.log.levels.ERROR)
		return
	end

	local api_url = "https://api.github.com/repos/" .. owner_repo .. "/commits/" .. sha .. "/pulls"

	local headers = { Accept = "application/vnd.github.v3+json" }
	if token ~= nil then
		if type(token) == "function" then
			token = token()
		end
		headers["Authorization"] = "token " .. token
	end

	local response = curl.get(api_url, { headers = headers })

	if response.status ~= 200 then
		vim.notify("Failed to get PRs: " .. response.body, vim.log.levels.ERROR)
		return
	end

	local prs = vim.fn.json_decode(response.body)
	for _, pr in ipairs(prs) do
		if pr.html_url then
			return pr.html_url
		end
	end

	vim.notify("No PR found for commit SHA: " .. sha, vim.log.levels.INFO)
	return nil
end

return M
