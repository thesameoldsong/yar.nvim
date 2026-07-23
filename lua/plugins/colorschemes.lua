-- Колорсхемы для схем theming (~/.config/theming/schemes/*/nvim.lua).
-- lazy = true: lazy.nvim сам подгружает плагин при вызове :colorscheme,
-- так что постоянно загружена только активная схема.
return {
  { 'ellisonleao/gruvbox.nvim', lazy = true },
  { 'shaunsingh/nord.nvim', lazy = true },
  { 'sainnhe/everforest', lazy = true },
  { 'rose-pine/neovim', name = 'rose-pine', lazy = true },
  { 'rebelot/kanagawa.nvim', lazy = true },
  { 'Mofiqul/vscode.nvim', lazy = true },
}
