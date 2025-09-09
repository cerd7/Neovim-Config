local home = os.getenv("HOME")
local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local on_attach = function(client, bufnr)
  -- Coloca aqui os atalhos que quiser ativar com o LSP
end

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', home .. '/.local/share/nvim/lsp_servers/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_1.7.0.v20250424-1814.jar',
    '-configuration', home .. '/.local/share/nvim/lsp_servers/eclipse.jdt.ls/config_linux',
    '-data', workspace_folder
  },
  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'build.gradle'}),
  settings = {
    java = {}
  },
  init_options = {
    bundles = {}
  },
  filetypes = { "java" },
  on_attach = on_attach,
}

require('jdtls').start_or_attach(config)

