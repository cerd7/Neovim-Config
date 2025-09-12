local M = {}

M.on_attach = function(client, bufnr)
  local map = vim.keymap.set
  local opts = { noremap=true, silent=true, buffer=bufnr }

  map('n', 'gd', vim.lsp.buf.definition, opts)
  map('n', 'gD', vim.lsp.buf.declaration, opts)
  map('n', 'gr', vim.lsp.buf.references, opts)
  map('n', 'gi', vim.lsp.buf.implementation, opts)
  map('n', 'gk', vim.lsp.buf.hover, opts)
  map('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  map('n', '<leader>rn', vim.lsp.buf.rename, opts)
  map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  
  -- Formatação condicional
  if client.server_capabilities.documentFormattingProvider then
    map('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
  end
  
  -- Navegação de diagnósticos
  map('n', '<leader>e', vim.diagnostic.open_float, opts)
  map('n', '[d', vim.diagnostic.goto_prev, opts)
  map('n', ']d', vim.diagnostic.goto_next, opts)
  map('n', '<leader>q', vim.diagnostic.setloclist, opts)
end

-- Auto-formatação ao salvar para arquivos web
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.css", "*.scss", "*.html", "*.vue" },
  callback = function()
    local clients = vim.lsp.get_active_clients()
    for _, client in ipairs(clients) do
      if client.server_capabilities.documentFormattingProvider then
        vim.lsp.buf.format({ async = false })
        break
      end
    end
  end,
})

return M
