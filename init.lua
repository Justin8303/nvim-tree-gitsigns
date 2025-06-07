local M = {}

function M.setup_tree()
  local gs_config = package.loaded['gitsigns.config'] and package.loaded['gitsigns.config'].config or {}
  local signs = gs_config.signs or {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '+' },
  }

  local git_glyphs = {
    unstaged  = signs.change and signs.change.text or '~',
    staged    = signs.add and signs.add.text or '+',
    unmerged  = signs.changedelete and signs.changedelete.text or '~',
    renamed   = signs.change and signs.change.text or '~',
    untracked = signs.untracked and signs.untracked.text or (signs.add and signs.add.text or '+'),
    deleted   = signs.delete and signs.delete.text or '_',
    ignored   = "◌",
  }

  require("nvim-tree").setup {
    renderer = {
      group_empty = true,
      icons = {
        glyphs = {
          git = git_glyphs,
        },
      }
    },
    sort = { sorter = "case_sensitive" },
    view = { width = 36 },
    filters = { dotfiles = true },
  }
end

function M.setup_colors()
local git_map = {
      Staged    = "GitSignsAdd",
      Untracked = "GitSignsUntracked",
      Deleted   = "GitSignsDelete",
      Dirty     = "GitSignsChange",
      Renamed   = "GitSignsChange",
      Unmerged  = "GitSignsChangeDelete",
      Ignored   = "Comment",
    }
    for tree, gs in pairs(git_map) do
      local group = "NvimTreeGit" .. tree .. "Icon"
      local ok, t = pcall(vim.api.nvim_get_hl, 0, { name = gs })
      if ok and t.fg then
        vim.api.nvim_set_hl(0, group, { fg = string.format("#%06x", t.fg) })
      end
    end
    local ok, api = pcall(require, "nvim-tree.api")
    if ok then api.tree.reload() end

end

function M.post_setup()
  M.setup_tree()
  M.setup_colors()
end

function M.setup()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("NvimTreeGitColors", { clear = true }),
    pattern = "*",
    callback = function()
      vim.defer_fn(M.post_setup, 100)
    end,
  })
end

return M
