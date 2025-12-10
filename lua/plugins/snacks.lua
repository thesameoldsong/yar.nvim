return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  --@type snacks.Config
  opts = {
    image = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    explorer = {
      replace_netrw = true,
      trash = true,
    },
    picker = {
      sources = {
        explorer = {
          jump = { close = true },
          layout = { preset = 'vscode' },
        },
      },
    },
    animate = {
      enabled = true,
    },
  },
  keys = {
    {
      '<leader>e',
      function()
        require('snacks').explorer()
      end,
      desc = 'File Explorer',
    },
  },
}
