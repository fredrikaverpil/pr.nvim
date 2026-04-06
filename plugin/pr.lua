vim.api.nvim_create_user_command("PRView", function()
  require("pr").view()
end, {
  desc = "View pull request in browser",
})
