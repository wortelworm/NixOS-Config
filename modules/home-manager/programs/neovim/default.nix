{ inputs, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  # adds and configures neovim using
  # https://github.com/nix-community/nixvim
  # todo: git, better terminal oil settings,
  # number of tabs, oil settings
  programs.nixvim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    colorschemes.vscode.enable = true;

    opts = {
      updatetime = 500;

      relativenumber = true;
      number = true; # Display the absolute line number of the current line
    };


    plugins = {
      lualine.enable = true;
      comment.enable = true;
      telescope.enable = true;
      treesitter = {
        enable = true;

      };
      oil = {
        enable = true;
        settings.delete_to_trash = true;
      };

      lsp = {
        enable = true;
        servers = {
          # tsserver.enable = true;
          rust-analyzer.enable = true;
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
          "<C-e>" = "cmp.mapping.close()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
        };
      };

      # todo more stuff
    };
  };
}
