local curl = require("plenary.curl")

local M = {}

--- Get the GitHub pull request URL for the given git remote and commit SHA.
---@param url string The remote URL, e.g. https://github.com/fredrikaverpil/neotest-golang.git
---@param sha string The commit SHA, e.g. 123abc
---@param token string|nil The GitHub token for private repositories (optional)
function M.get_pr_url(url, sha, token)
	local owner_repo = string.match(url, "github.com/([^/]+/[^/]+)%.git")
	if not owner_repo then
		return
	end

	local api_url = "https://api.github.com/repos/" .. owner_repo .. "/commits/" .. sha .. "/pulls"

	vim.notify(api_url)

	local headers = { Accept = "application/vnd.github.v3+json" }
	if token then
		if type(M.token) == "function" then
			M.opts.token = M.token()
		end
		headers["Authorization"] = "token " .. token
	end

	local response = curl.get(api_url, { headers = headers })
	local prs = vim.fn.json_decode(response.body)
	for _, pr in ipairs(prs) do
		if pr.html_url then
			return pr.html_url
		end
	end

	return nil
end

return M
