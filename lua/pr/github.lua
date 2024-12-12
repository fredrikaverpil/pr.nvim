local M = {}

--- Curl the GitHub API to get the PRs for the given commit SHA.
---@param owner_repo string The owner/repo, e.g. fredrikaverpil/neotest-golang
---@param sha string The commit SHA, e.g. 123abc
---@param token string|fun():string The GitHub token for private repositories
---@return table|nil
local function curl_api(owner_repo, sha, token)
	local curl = require("plenary.curl")
	local api_url = "https://api.github.com/repos/" .. owner_repo .. "/commits/" .. sha .. "/pulls"

	local headers = { Accept = "application/vnd.github.v3+json" }
	if type(token) == "function" then
		token = token()
	end
	headers["Authorization"] = "token " .. token

	local response = curl.get(api_url, { headers = headers })

	if response.status ~= 200 then
		vim.notify("Failed to get PRs: " .. response.body, vim.log.levels.ERROR)
		return
	end

	return vim.fn.json_decode(response.body)
end

--- Call the GitHub CLI to get the PRs for the given commit SHA.
---@param owner_repo string The owner/repo, e.g. fredrikaverpil/neotest-golang
---@param sha string The commit SHA, e.g. 123abc
---@return table|nil
local function call_api_via_gh(owner_repo, sha)
	local cmd = { "gh", "api", "repos/" .. owner_repo .. "/commits/" .. sha .. "/pulls" }
	local obj = vim.system(cmd, { text = true }):wait()
	if obj.code == 0 then
		return vim.fn.json_decode(obj.stdout)
	end
end

--- Get the GitHub pull request URL for the given git remote and commit SHA.
---@param url string The remote URL, e.g. https://github.com/fredrikaverpil/neotest-golang.git
---@param sha string The commit SHA, e.g. 123abc
---@param token string|fun():string|nil The GitHub token for private repositories (optional)
---@return string|nil
function M.get_pr_url(url, sha, token)
	local owner_repo = string.match(url, "github.com/([^/]+/[^/]+)%.git")
	if not owner_repo then
		vim.notify("Failed to get owner/repo from URL: " .. url, vim.log.levels.ERROR)
		return
	end

	---@type table|nil
	local json_response = {}

	-- if token was provided, use curl.
	if token ~= nil then
		json_response = curl_api(owner_repo, sha, token)
	elseif vim.fn.executable("gh") == 1 then
		json_response = call_api_via_gh(owner_repo, sha)
	elseif vim.fn.executable("gh") == 0 then
		vim.notify("gh is not installed", vim.log.levels.ERROR)
		return
	end

	-- local prs = vim.fn.json_decode(response.body)
	for _, pr in ipairs(json_response) do
		if pr.html_url then
			return pr.html_url
		end
	end

	vim.notify("No PR found for commit SHA: " .. sha, vim.log.levels.INFO)
	return nil
end

return M
