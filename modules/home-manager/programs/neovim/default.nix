{ inputs, lib, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  # adds and configures neovim using
  # https://github.com/nix-community/nixvim
  # todo: git, better terminal, oil settings
  # automatic brackets and indentation, clipboard, tabs
  # latex
  programs.nixvim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    colorschemes.vscode.enable = true;

    opts = {
      # apperently this is being set by gitgutter
      # updatetime = 500;

      expandtab = true;
      autoindent = true;

      relativenumber = true;
      number = true; # Display the absolute line number of the current line
    };

    plugins = {
      lualine.enable = true;
      comment.enable = true;
      telescope.enable = true;
      gitgutter.enable = true;
      treesitter = {
        enable = true;
        indent = true;
	# maybe disable some contexts because I dont need them all
      };
      oil = {
        enable = true;
        settings.delete_to_trash = true;
      };

      lsp = {
        enable = true;
        servers = {
          # tsserver.enable = true;

          rust-analyzer = {
            enable = true;
            # these are managed by rustup
            installCargo = false;
            installRustc = false;
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
          # "<C-e>" = "cmp.mapping.close()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
        };
      };

      
      # todo more stuff
    };

    keymaps = let
      normal =
        lib.mapAttrsToList
        (key: action: {
          mode = "n";
          inherit action key;
        })
        {
          # Using tabs like in other programs
          "<C-t>" = ":tabnew <CR>";
          "<C-Tab>" = ":tabnext + <CR>";
          "<CS-Tab>" = ":tabnext - <CR>";
          "<C-e>" = "<C-w>";
          "<C-w>" = ":tabclose <CR>";
  
          # integrated terminal?
        };
      in
        normal;
  };
}
