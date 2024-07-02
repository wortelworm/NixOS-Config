{ inputs, lib, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  # adds and configures neovim using
  # https://github.com/nix-community/nixvim
  # todo: git, zooming in and out,
  # automatic brackets and indentation, clipboard, tabs, better scrolling
  # latex, competative programming, ...
  # transparency?
  programs.nixvim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    colorschemes.onedark = {
      enable = true;
      # make sure this is lowercase and matches exactly
      settings.style = "darker";
    };
    
    # use clipboard with ctrl+shift c
    # pasting works, but copying doesnt :(
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    opts = {
      relativenumber = true;
      number = true; # Display the absolute line number of the current line

      expandtab = true;
      autoindent = true;
      shiftwidth = 4;
      tabstop = 4;
    };

    plugins = {
      lualine.enable = true;
      comment.enable = true;
      nvim-autopairs.enable = true;
      diffview.enable = true;
      neoscroll.enable = true;
      # maybe use gitsigns?
      gitgutter.enable = true;
      # would be cool to see the background as a toggle,
      # but I would need to configure kitty to work with that
      # transparent.enable = true;
      treesitter = {
        enable = true;
        indent = true;
        # maybe disable some contexts because I dont need them all
      };
      neo-tree = {
        enable = true;
        closeIfLastWindow = true;
        window = {
          width = 30;
          autoExpandWidth = true;
        };
      };
      toggleterm = {
        enable = true;
        settings = {
          direction = "horizontal";
          size = 15;
        };
      };

      telescope = {
        enable = true;

        extensions = {
          # better selection ui, used for code actions
          ui-select.enable = true;
        };
      };


      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          tsserver.enable = true;
          clangd.enable = true;
          nil-ls.enable = true;

          rust-analyzer = {
            enable = true;
            # these are managed by rustup
            installCargo = false;
            installRustc = false;
            settings = {
              check.command = "clippy";
              # inlayHints.bindingModeHints.enable = true;
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
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
        };
      };

      
      # todo more stuff
    };

    globals.mapleader = " ";

    keymaps = let
      normal =
        lib.mapAttrsToList
        (key: action: {
          mode = "n";
          inherit action key;
        })
        {
          # show tree sidebar
          "<C-b>" = ":Neotree <CR>";

          # show terminal
          "<C-\\>" = ":ToggleTerm <CR>";

          # Using tabs like in other programs
          # this is not working ????
          # lets try to use barbar
          # or maybe dont show any tabs what so ever?
          # "<C-t> <C-t>" = ":tabnew <CR>";
          # "<C-t>" = ":tabnew <CR>";
          # "<C-t> l" = ":tabnext + <CR>";
          # "<C-t> h" = ":tabnext - <CR>";
          # "<C-t> <C-w>" = ":tabclose <CR>";

          # resize windows with arrows
          "<C-Up>" = ":resize -2<CR>";
          "<C-Down>" = ":resize +2<CR>";
          "<C-Left>" = ":vertical resize +2<CR>";
          "<C-Right>" = ":vertical resize -2<CR>";

          # lsp stuff?
          # autofix menu
          "<leader>h" = "<cmd>lua vim.lsp.buf.hover()<CR>";
          "<leader>a" = "<cmd>lua vim.lsp.buf.code_action()<CR>";
          "<leader>e" = "<cmd>lua vim.diagnostic.open_float()<CR>";

          # TODO: make shortcuts for diffview
          # or use telescope to view git stuff
        };
      vni =
        lib.mapAttrsToList
        (key: action: {
          mode = [ "n" "v" "i" ];
          inherit action key;
        })
        {
          # copy, cut, paste
          "<CS-c>" = "\"+y";
          "<CS-x>" = "\"+c";
          "<CS-v>" = "\"+p";

          # saving
          "<C-s>" = "<cmd>w<CR>";
        };
      in
        normal ++ vni;
  };
}
