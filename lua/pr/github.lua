-- curl -s "https://api.github.com/repos/fredrikaverpil/neotest-golang/commits/abc123/pulls" \
--  -H "Accept: application/vnd.github.v3+json"
--
-- Then get each object returned, and access its "html_url" field for the PR.

local curl = require("plenary.curl")

local M = {}

--- Get the GitHub pull request URL for the given git remote and commit SHA.
---@param url string The remote URL, e.g. https://github.com/fredrikaverpil/neotest-golang.git
---@param sha string The commit SHA, e.g. 123abc
function M.get_pr_url(url, sha)
	local owner_repo = string.match(url, "github.com/([^/]+/[^/]+)%.git")
	if not owner_repo then
		return
	end

	local api_url = "https://api.github.com/repos/" .. owner_repo .. "/commits/" .. sha .. "/pulls"
	local headers = { Accept = "application/vnd.github.v3+json" }
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
