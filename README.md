# pr.nvim

View pull request, related to line under cursor, in web browser.

## Features ⭐

- Supports git repositories cloned down with https or ssh.
- GitHub pull requests.

## Requirements

- Neovim version 0.10.0 and higher.
- For GitHub PRs: [`gh-cli`](https://cli.github.com/) (or alternatively, `curl` via
  [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)).

## Install 🚀

### Lazy.nvim 💤

```lua
return {
  {
    "fredrikaverpil/pr.nvim",
    lazy = true,
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

Out of the box, `gh-cli` will be used to query for pull requests. This should be
sufficient to e.g. access private repositories. Example:

```bash
gh api repos/fredrikaverpil/pr.nvim/commits/c0765e2b0fd44494f1ec19b58c90e4381afbea28/pulls
```

If you would rather use a personal access token (a
[PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens),
managed [in your GitHub settings/tokens](https://github.com/settings/tokens)),
you can define the `github_token` option. You will then also have to add the
dependency to `nvim-lua/plenary.nvim`.

> [!WARNING]
>
> Don't store the token as a string directly in your config. For example, use a
> password manager or `os.getenv`.

Example use with 1Password:

```lua
return {
  "fredrikaverpil/pr.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    github_token = function()
      local cmd = { "op", "read", "op://Personal/github.com/tokens/pr.nvim", "--no-newline" }
      local obj = vim.system(cmd, { text = true }):wait()
      if obj.code ~= 0 then
        vim.notify("Failed to get token from 1Password", vim.log.levels.ERROR)
        return nil
      end
      return obj.stdout
    end,
  },
}
```
