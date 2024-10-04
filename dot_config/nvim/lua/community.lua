-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- Color theme
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  -- Language packs
  { import = "astrocommunity.pack.lua" },
  -- import/override with your plugins folder
}
