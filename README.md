# pr.nvim

Open pull request, related to line under cursor, in web browser.

## Features ⭐

- GitHub pull requests.

## Install 🚀

### Lazy.nvim 💤

```lua
return {
  {
    "fredrikaverpil/pr.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {},
    keys = {
      {
        "<leader>o",
        function()
          require("pr").open()
        end,
        desc = "Open PR",
      },
    },
  },
}
```

## Usage 🤙

Either define a keymap (example above), or execute `:PROpen`.

## Custom opts ⚙️

- `token`: the token required for the API, if e.g. querying private
  repositories.
