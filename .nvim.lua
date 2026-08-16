local root = os.getenv("HOME") .. "/system.nix"

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "nixd" or client.root_dir ~= root then
      return
    end
    client.settings.nixd.options = {
      home_manager = {
        expr = '(builtins.getFlake "' .. root .. '").homeConfigurations.aarch64.options',
      },
      nix_darwin = {
        expr = '(builtins.getFlake "' .. root .. '").darwinConfigurations.aarch64.options',
      },
    }
    client:notify("workspace/didChangeConfiguration", { settings = client.settings })
  end,
})
