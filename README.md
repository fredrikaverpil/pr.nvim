# pr.nvim

View pull request, related to line under cursor, in web browser.

## Features ⭐

- Supports git repositories cloned down with https or ssh.
- GitHub pull requests.

## Requirements

- Neovim version 0.10.0 and higher.
- Curl (via [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)).

## Install 🚀

### Lazy.nvim 💤

```lua
return {
  {
    "fredrikaverpil/pr.nvim",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    version = "*",
    ---@type PR.Config
    opts = {},
    keys = {
      {
        "<leader>gv",
        function()
          require("pr").view()
        end,
        desc = "View PR in browser",
      },
    },
    cmd = { "PRView" },
  },
}
```

## Custom opts ⚙️

### `github_token` (optional)

The personal access token (PAT), required for querying private repositories.

> [!WARNING]
>
> Don't store the token as a string directly in your config. For example, use a
> password manager or `os.getenv`.

Example use with 1Password:

```lua
opts = {
  github_token = function()
    local cmd = { "op", "read", "op://Personal/github.com/tokens/pr.nvim", "--no-newline" }
    local obj = vim.system(cmd, { text = true }):wait()
    if obj.code ~= 0 then
      vim.notify("Failed to get token from 1Password", vim.log.levels.ERROR)
      return nil
    end
    return obj.stdout
  end
}
```
