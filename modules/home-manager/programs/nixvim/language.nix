{
  inputs,
  wortel,
  ...
}: {
  # suggested by nixd documentation
  nix.nixPath = ["nixpkgs=${inputs.nixos}"];

  programs.nixvim = {
    # Some langauges have indentation of 2 spaces by default
    # autocmd FileType typescript setlocal shiftwidth=2
    # events file-patern command
    # to view current filetype: lua vim.fn.input(vim.bo.filetype)
    autoCmd =
      builtins.map (name: {
        event = "FileType";
        pattern = name;
        command = "setlocal shiftwidth=2";
      })
      ["nix" "haskell"];

    plugins = {
      treesitter = {
        enable = true;
        indent = true;
      };

      lsp-lines.enable = true;

      lsp = {
        enable = true;
        # TODO enable once upgrading from 24.05
        # inlayHints = true;
        onAttach = ''
          -- LSP Inlay Hints {{{
          if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
          -- }}}
        '';

        servers = {
          tsserver.enable = true;
          clangd.enable = true;
          hls.enable = true;

          nixd = {
            enable = true;
            settings = {
              nixpkgs.expr = "import <nixpkgs> { }";
              formatting.command = ["alejandra"];
              options.nixos.expr = "(builtins.getFlake \"${wortel.flakePath}\").nixosConfigurations.${wortel.hostname}.options";
            };
          };

          rust-analyzer = {
            enable = true;
            # these are managed by rustup
            installCargo = false;
            installRustc = false;
            settings = {
              check.command = "clippy";

              # I never use them and they take up a lot of space on the menu
              completion.postfix.enable = false;

              inlayHints.chainingHints.enable = false;

              # Idk why this shows up
              diagnostics.disabled = ["unresolved-proc-macro"];
            };
          };
        };
      };

      cmp = {
        enable = true;
        settings.sources = [
          {name = "nvim_lsp";}
          {name = "path";}
          {name = "buffer";}
        ];
        settings.mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<C-e>" = "cmp.mapping.close()";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<C-u>" = "cmp.mapping.scroll_docs(-4)";
          "<C-d>" = "cmp.mapping.scroll_docs(4)";
        };
      };
    };
  };
}
