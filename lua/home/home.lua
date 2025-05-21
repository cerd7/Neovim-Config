local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Arte estilizada
dashboard.section.header.val = {
  [[███╗   ██╗██╗   ██╗██╗███╗   ███╗]],
  [[████╗  ██║██║   ██║██║████╗ ████║]],
  [[██╔██╗ ██║██║   ██║██║██╔████╔██║]],
  [[██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
  [[██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║]],
  [[╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝]],
  [[        🧠 Comandante CERD        ]]
}

-- Menu com atalhos e ícones
dashboard.section.buttons.val = {
  dashboard.button("f", "🔍  Buscar arquivos", ":Telescope find_files<CR>"),
  dashboard.button("r", "🕘  Recentes", ":Telescope oldfiles<CR>"),
  dashboard.button("n", "📝  Novo arquivo", ":ene <BAR> startinsert <CR>"),
  dashboard.button("s", "📁  Sessões salvas", ":SessionManager load_session<CR>"),
  dashboard.button("c", "⚙️   Configurações", ":e ~/.config/nvim/init.vim<CR>"),
  dashboard.button("q", "❌  Sair", ":qa<CR>"),
}

-- Rodapé com dica
dashboard.section.footer.val = "💡 Clean code é poesia em movimento."

-- Remover todos os autocommands para não afetar edição
dashboard.opts.opts.noautocmd = true

-- Protege o buffer contra edição
vim.api.nvim_create_autocmd("User", {
  pattern = "AlphaReady",
  callback = function()
    vim.opt_local.modifiable = false
    vim.opt_local.readonly = true
  end,
})

alpha.setup(dashboard.opts)

