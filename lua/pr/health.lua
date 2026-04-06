local M = {}

function M.check()
  vim.health.start("pr.nvim")

  -- Check plenary
  local ok = pcall(require, "plenary.curl")
  if ok then
    vim.health.ok("plenary.nvim found (used for token-based auth)")
  else
    vim.health.warn("plenary.nvim not found — token-based GitHub auth unavailable")
  end

  -- Check gh CLI
  if vim.fn.executable("gh") == 1 then
    vim.health.ok("gh CLI found")
  else
    vim.health.warn("gh CLI not found — install it or provide a github_token in setup()")
  end

  -- Check git
  if vim.fn.executable("git") == 1 then
    vim.health.ok("git found")
  else
    vim.health.error("git not found in PATH")
  end
end

return M
