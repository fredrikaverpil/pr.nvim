if vim.g.loaded_pr then
  return
end
vim.g.loaded_pr = true

vim.api.nvim_create_user_command("PRView", function()
  require("pr").view()
end, {
  desc = "View pull request in browser",
})
