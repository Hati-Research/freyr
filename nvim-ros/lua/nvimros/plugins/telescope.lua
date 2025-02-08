
return {
  {
   'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
	local telescope = require 'telescope'
	local actions = require 'telescope.actions'
	local builtin = require 'telescope.builtin'
	local themes = require 'telescope.themes'

      telescope.setup {
        defaults = vim.tbl_extend('force', themes.get_dropdown(), {
          file_ignore_patterns = {
            '.git/',
          },
          mappings = {
            i = {
              ['<esc>'] = actions.close,
              ['<C-y>'] = actions.select_default,
            },
          },
        }),
        pickers = {
          find_files = {
            theme = 'dropdown',
          },
        },
        extensions = {
          fzf = {},
          -- make internal neovim code fill telescope if possible
          ['ui-select'] = {
            themes.get_dropdown {},
          },
        },
      }
      -- TODO: kickstart loads it differently, find out if needed
      telescope.load_extension 'ui-select'
      -- TODO: move to keymap definitions
      local simple_keymap = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { desc = desc })
      end
      simple_keymap('<leader><leader>', builtin.buffers, '[S]earch open buffers')
      simple_keymap('<leader>sf', function()
        builtin.find_files { hidden = true }
      end, '[S]earch [F]iles')
      simple_keymap('<leader>sg', builtin.live_grep, '[S]earch [G]rep')
      simple_keymap('<leader>sh', builtin.help_tags, '[S]earch [H]elp')
      simple_keymap('<leader>sk', builtin.keymaps, '[S]earch [K]eymaps')
      simple_keymap('<leader>sr', builtin.resume, '[S]earch [R]esume')
      simple_keymap('leader>su', builtin.builtin, '[S]earch [U]ltimate')
      vim.keymap.set('n', '<leader>sp', function()
        require('telescope.builtin').find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath 'data', 'lazy'),
        }
      end, { desc = '[S]earch [P]lugins' })

      -- NOTE: tj has a snippet about configuring more opts for the find_files function call
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files {
          cwd = vim.fn.stdpath 'config',
        }
      end, { desc = '[S]earch [N]eoVIM' })
    end,
  },
}
