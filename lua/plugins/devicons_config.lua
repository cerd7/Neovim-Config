local present, nvim_web_devicons = pcall(require, "nvim-web-devicons")

if not present then
  return
end
nvim_web_devicons.setup({
  override = {
    js = {
      icon = "",
      color = "#f7df1e",
      name = "JavaScript"
    },
    ts = {
      icon = "ﯤ",
      color = "#3178c6",
      name = "TypeScript"
    },
    css = {
      icon = "",
      color = "#264de4",
      name = "CSS"
    },
    html = {
      icon = "",
      color = "#e44d26",
      name = "HTML"
    },
    vue = {
      icon = "﵂",
      color = "#41b883",
      name = "Vue"
    },
    java = {
      icon = "",
      color = "#f89820",
      name = "Java"
    }
  },
  color_icons = true,
  default = true,
  strict = true,
  override_by_filename = {
    ["package.json"] = {
      icon = "",
      color = "#8bc34a",
      name = "PackageJson"
    },
  },
})

-- Adicionar integração com bufferline se estiver presente
pcall(function()
  require("bufferline").setup {
    options = {
      buffer_close_icon = '',
      modified_icon = '●',
      close_icon = '',
      left_trunc_marker = '',
      right_trunc_marker = '',
      diagnostics = "nvim_lsp",
      show_buffer_icons = true,
    }
  }
end)

-- Adicionar integração com lualine se estiver presente
pcall(function()
  require('lualine').setup {
    options = {
      icons_enabled = true,
      theme = 'auto',
    }
  }
end)
