-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Restore builtin H/L (top/bottom of window). LazyVim remaps them to buffer
-- cycling (bprevious/bnext, also on [b/]b — those keep working). This file is
-- sourced by LazyVim AFTER its own keymaps on VeryLazy, so these win.
vim.keymap.set("n", "H", "H", { desc = "Top of window" })
vim.keymap.set("n", "L", "L", { desc = "Bottom of window" })
