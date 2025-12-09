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
