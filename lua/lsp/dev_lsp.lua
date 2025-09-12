local M = {}

-- Verificar se o lspconfig está disponível
local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
  vim.notify("lspconfig não encontrado. Execute :PlugInstall nvim-lspconfig", vim.log.levels.ERROR)
  return M
end

-- Tentar carregar o lsp_keymap
local on_attach
local status_keymap_ok, lsp_keymap = pcall(require, "lsp.lsp_keymap")
if status_keymap_ok then
  on_attach = lsp_keymap.on_attach
else
  -- Fallback para uma função básica de on_attach caso o módulo não seja encontrado
  vim.notify("lsp_keymap não encontrado, usando configuração básica", vim.log.levels.WARN)
  on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  end
end

-- Capacidades compartilhadas para todos os servidores
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Verificar se há suporte para nvim-cmp
local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_ok then
  capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
end

-- Verificar binário no PATH
local function binary_exists(binary_name)
  local handle = io.popen("which " .. binary_name .. " 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result and result ~= ""
  end
  return false
end

-- Configuração para TypeScript/JavaScript
if binary_exists("typescript-language-server") then
  vim.notify("Configurando TypeScript/JavaScript LSP", vim.log.levels.INFO)
  lspconfig.tsserver.setup {
    on_attach = function(client, bufnr)
      vim.notify("TypeScript LSP anexado ao buffer " .. bufnr, vim.log.levels.INFO)
      if on_attach then
        on_attach(client, bufnr)
      end
    end,
    capabilities = capabilities,
    filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "typescript.tsx", "javascript.jsx" },
    root_dir = function(fname)
      return lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")(fname) or vim.fn.getcwd()
    end,
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        }
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        }
      }
    },
    flags = {
      debounce_text_changes = 150,
    }
  }
else
  vim.notify("typescript-language-server não encontrado. Execute ~/.config/nvim/scripts/install_web_lsp.sh", vim.log.levels.WARN)
end

-- Configuração para CSS
if binary_exists("vscode-css-language-server") then
  vim.notify("Configurando CSS LSP", vim.log.levels.INFO)
  lspconfig.cssls.setup {
    on_attach = function(client, bufnr)
      vim.notify("CSS LSP anexado ao buffer " .. bufnr, vim.log.levels.INFO)
      if on_attach then
        on_attach(client, bufnr)
      end
    end,
    capabilities = capabilities,
    filetypes = { "css", "scss", "less" },
    root_dir = function(fname)
      return lspconfig.util.root_pattern("package.json", ".git")(fname) or vim.fn.getcwd()
    end,
    settings = {
      css = {
        validate = true,
        lint = {
          unknownAtRules = "ignore"
        }
      },
      scss = {
        validate = true
      },
      less = {
        validate = true
      }
    }
  }
else
  vim.notify("CSS language server não encontrado. Execute ~/.config/nvim/scripts/install_web_lsp.sh", vim.log.levels.WARN)
end

-- Configuração para HTML
if binary_exists("vscode-html-language-server") then
  vim.notify("Configurando HTML LSP", vim.log.levels.INFO)
  lspconfig.html.setup {
    on_attach = function(client, bufnr)
      vim.notify("HTML LSP anexado ao buffer " .. bufnr, vim.log.levels.INFO)
      if on_attach then
        on_attach(client, bufnr)
      end
    end,
    capabilities = capabilities,
    filetypes = { "html" },
    root_dir = function(fname)
      return lspconfig.util.root_pattern("package.json", ".git")(fname) or vim.fn.getcwd()
    end,
    init_options = {
      configurationSection = { "html", "css", "javascript" },
      embeddedLanguages = {
        css = true,
        javascript = true
      },
      provideFormatter = true
    }
  }
else
  vim.notify("HTML language server não encontrado. Execute ~/.config/nvim/scripts/install_web_lsp.sh", vim.log.levels.WARN)
end

-- Funções de diagnóstico e resolução de problemas
function M.check_lsp_status()
  local clients = vim.lsp.get_active_clients()
  if #clients == 0 then
    vim.notify("Nenhum cliente LSP ativo", vim.log.levels.WARN)
    return
  end
  
  for _, client in ipairs(clients) do
    vim.notify(string.format("LSP ativo: %s (ID: %d)", client.name, client.id), vim.log.levels.INFO)
  end
end

function M.restart_lsp()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
  vim.notify("Reiniciando LSP...", vim.log.levels.INFO)
  -- Recarregar a configuração
  require("lsp.dev_lsp")
  vim.notify("LSP reiniciado", vim.log.levels.INFO)
end

function M.start_lsp_manually(server_name)
  local status_ok, lspconfig = pcall(require, "lspconfig")
  if not status_ok then
    vim.notify("lspconfig não encontrado", vim.log.levels.ERROR)
    return
  end
  
  if lspconfig[server_name] then
    lspconfig[server_name].launch()
    vim.notify(server_name .. " iniciado manualmente", vim.log.levels.INFO)
  else
    vim.notify("Servidor LSP não encontrado: " .. server_name, vim.log.levels.ERROR)
  end
end

-- Comando Vim para verificar status do LSP
vim.api.nvim_create_user_command("LspStatus", function()
  M.check_lsp_status()
end, {})

-- Comando Vim para reiniciar LSP
vim.api.nvim_create_user_command("LspRestart", function()
  M.restart_lsp()
end, {})

-- Comando Vim para iniciar LSP manualmente
vim.api.nvim_create_user_command("LspStart", function(opts)
  M.start_lsp_manually(opts.args)
end, { nargs = 1 })

return M