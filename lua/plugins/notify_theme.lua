-- Tema moderno para nvim-notify
-- filepath: /home/cerddev/.config/nvim/lua/plugins/notify_theme.lua

local M = {}

-- Tema Catppuccin Mocha para notify
M.catppuccin_mocha = {
  normal = {
    fg = "#cdd6f4",
    bg = "#1e1e2e",
  },
  border = {
    fg = "#89b4fa",
    bg = "#1e1e2e",
  },
  title = {
    fg = "#89b4fa",
    bg = "#1e1e2e",
  },
}

-- Tema Nord para notify
M.nord = {
  normal = {
    fg = "#d8dee9",
    bg = "#2e3440",
  },
  border = {
    fg = "#88c0d0",
    bg = "#2e3440",
  },
  title = {
    fg = "#88c0d0",
    bg = "#2e3440",
  },
}

-- Tema Dracula para notify
M.dracula = {
  normal = {
    fg = "#f8f8f2",
    bg = "#282a36",
  },
  border = {
    fg = "#bd93f9",
    bg = "#282a36",
  },
  title = {
    fg = "#bd93f9",
    bg = "#282a36",
  },
}

-- Tema Tokyo Night para notify
M.tokyo_night = {
  normal = {
    fg = "#c0caf5",
    bg = "#1a1b26",
  },
  border = {
    fg = "#7dcfff",
    bg = "#1a1b26",
  },
  title = {
    fg = "#7dcfff",
    bg = "#1a1b26",
  },
}

-- Aplicar tema
function M.apply_theme(theme_name)
  local theme = M[theme_name] or M.catppuccin_mocha

  vim.cmd(string.format([[
    highlight NotifyERRORBorder guifg=#f38ba8 guibg=%s
    highlight NotifyWARNBorder guifg=#f9e2af guibg=%s
    highlight NotifyINFOBorder guifg=#89b4fa guibg=%s
    highlight NotifyDEBUGBorder guifg=#a6e3a1 guibg=%s
    highlight NotifyTRACEBorder guifg=#f5c2e7 guibg=%s

    highlight NotifyERRORIcon guifg=#f38ba8
    highlight NotifyWARNIcon guifg=#f9e2af
    highlight NotifyINFOIcon guifg=#89b4fa
    highlight NotifyDEBUGIcon guifg=#a6e3a1
    highlight NotifyTRACEIcon guifg=#f5c2e7

    highlight NotifyERRORTitle guifg=#f38ba8 gui=bold
    highlight NotifyWARNTitle guifg=#f9e2af gui=bold
    highlight NotifyINFOTitle guifg=#89b4fa gui=bold
    highlight NotifyDEBUGTitle guifg=#a6e3a1 gui=bold
    highlight NotifyTRACETitle guifg=#f5c2e7 gui=bold
  ]], theme.normal.bg, theme.normal.bg, theme.normal.bg, theme.normal.bg, theme.normal.bg))

  vim.notify("Tema " .. theme_name .. " aplicado às notificações!", "info", {
    title = "Tema Alterado",
    timeout = 2000
  })
end

-- Comandos para trocar temas
vim.api.nvim_create_user_command("NotifyTheme", function(opts)
  local theme = opts.args or "catppuccin_mocha"
  M.apply_theme(theme)
end, {
  nargs = "?",
  complete = function()
    return { "catppuccin_mocha", "nord", "dracula", "tokyo_night" }
  end,
  desc = "Alterar tema das notificações"
})

return M