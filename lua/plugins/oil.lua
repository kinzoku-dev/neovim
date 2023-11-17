return {
  'stevearc/oil.nvim',
  opts = {},
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    {
      '<leader>op',
      '<cmd>Oil<cr>',
      desc = 'File Browser',
    },
  },
  config = function()
    require('oil').setup {
      skip_confirm_for_simple_edits = true,
    }
  end,
}
