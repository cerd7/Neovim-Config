-- Configuração segura do nvim-notify
local M = {}

function M.setup()
  local status_ok, notify = pcall(require, "notify")
  if not status_ok then
    vim.notify("nvim-notify não encontrado. Execute :PlugInstall", vim.log.levels.WARN)
    return
  end

  -- Configuração simples e estável
  notify.setup({
    -- Aparência básica
    background_colour = "#1e1e2e",
    fps = 30,
    level = 2,
    minimum_width = 40,
    render = "default",

    -- Posicionamento no canto superior direito
    top_down = false,
    stages = "fade",

    -- Posição fixa
    row = 1,
    col = function()
      return vim.o.columns - 50
    end,

    -- Ícones
    icons = {
      DEBUG = "🐛",
      ERROR = "❌",
      INFO = "ℹ️",
      TRACE = "✎",
      WARN = "⚠️"
    },

    -- Tempo
    timeout = 3000,
  })

  -- Configurar vim.notify para usar o plugin
  vim.notify = notify

  -- Função para testar as notificações
  _G.test_notifications = function()
    vim.notify("Esta é uma mensagem de informação", "info", {
      title = "Teste INFO",
      timeout = 2000
    })
    vim.defer_fn(function()
      vim.notify("Esta é uma mensagem de aviso", "warn", {
        title = "Teste WARN",
        timeout = 2000
      })
    end, 1000)
    vim.defer_fn(function()
      vim.notify("Esta é uma mensagem de erro", "error", {
        title = "Teste ERROR",
        timeout = 2000
      })
    end, 2000)
  end

  -- Comando Vim para testar notificações
  vim.api.nvim_create_user_command("NotifyTest", function()
    _G.test_notifications()
  end, { desc = "Testar notificações do nvim-notify" })

  -- Comando para mostrar configuração
  vim.api.nvim_create_user_command("NotifyConfig", function()
    vim.notify("Notificações configuradas com sucesso!\n\n" ..
               "📍 Posição: Canto superior direito\n" ..
               "🎨 Tema: Catppuccin Mocha\n" ..
               "⏱️ Timeout: 3 segundos\n" ..
               "🎯 Teste com: :NotifyTest", "info", {
      title = "Notify Configurado",
      timeout = 5000
    })
  end, { desc = "Mostrar configuração atual do notify" })
end

return M
