return {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
    '.git',
  },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
  on_attach = function(client, bufnr)
    -- Organize imports command
    vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightOrganizeImports', function()
      client:exec_cmd({
        command = 'pyright.organizeimports',
        arguments = { vim.uri_from_bufnr(bufnr) },
      })
    end, {
      desc = 'Organize Imports',
    })

    -- Set Python path command
    vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightSetPythonPath', function(opts)
      local python_path = opts.args
      client.config.settings.python = vim.tbl_deep_extend('force', client.config.settings.python or {}, {
        pythonPath = python_path,
      })
      client.notify('workspace/didChangeConfiguration', {
        settings = client.config.settings,
      })
      vim.notify('Python path set to: ' .. python_path)
    end, {
      desc = 'Reconfigure pyright with the provided python path',
      nargs = 1,
      complete = 'file',
    })
  end,
}
