return {
  {
    "refractalize/oil-git-status.nvim",
    config = {
      show_ignored = true
    },
    dependencies = {
      "stevearc/oil.nvim",
      dependencies = {
        { "echasnovski/mini.icons", opts = {} },
      },
      opts = {
        skip_confirm_for_simple_edits = true,
        win_options = {
          signcolumn = "auto:2",
        },
        view_options = {
          show_hidden = true,
        },
        -- defaults but with window navigation keys removed
        keymaps = {
          ["g?"] = { "actions.show_help", mode = "n" },
          ["<CR>"] = "actions.select",
          ["<C-s>"] = { "actions.select", opts = { vertical = true } },
          ["<C-h>"] = false,
          ["<C-t>"] = { "actions.select", opts = { tab = true } },
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = { "actions.close", mode = "n" },
          ["<C-l>"] = false,
          ["-"] = { "actions.parent", mode = "n" },
          ["_"] = { "actions.open_cwd", mode = "n" },
          ["`"] = { "actions.cd", mode = "n" },
          ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
          ["gs"] = { "actions.change_sort", mode = "n" },
          ["gx"] = "actions.open_external",
          ["g."] = { "actions.toggle_hidden", mode = "n" },
          ["g\\"] = { "actions.toggle_trash", mode = "n" },
        },
      },
      config = function(_, opts)
        require("oil").setup(opts)
        vim.api.nvim_create_autocmd("User", {
          pattern = "OilEnter",
          callback = vim.schedule_wrap(function(args)
            local oil = require("oil")
            if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
              oil.open_preview()
            end
          end)
        })
      end
    }
  }
}
