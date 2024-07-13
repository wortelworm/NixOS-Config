{ inputs, lib, pkgs, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  home.packages = [
    # used by telescope find_files
    pkgs.fd
  ];

  # adds and configures neovim using
  # https://github.com/nix-community/nixvim
  # todo: git, zooming in and out,
  # better indentation,
  # latex, competative programming, ...
  # transparency?
  programs.nixvim = {
    enable = true;
    
    colorschemes.onedark = {
        enable = true;
        settings.style = "deep";
    };
    
    # keyboard shortcuts below
    clipboard = {
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
      gitsigns.enable = true;
      hop.enable = true;
      # would be cool to see the background as a toggle,
      # but I would need to configure kitty to work with that
      # transparent.enable = true;
      treesitter = {
        enable = true;
        indent = true;
        # maybe disable some contexts because I dont need them all
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
          media-files.enable = true;
          fzf-native.enable = true;
          # file-browser = {
          #   enable = true;
          #   settings.hijack_netrw = true;
          # };
        };
      };

      competitest = {
        enable = true;
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
          "<C-u>" = "cmp.mapping.scroll_docs(-4)";
          "<C-d>" = "cmp.mapping.scroll_docs(4)";
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
          # show terminal
          "<C-\\>" = "<cmd>ToggleTerm<CR>";

          # hop!
          "f" = "<cmd>HopWord<CR>";

          # telescope & lsp stuff
          "<leader>" = "<NOP>";
          "<leader>f" = "<cmd>Telescope find_files<CR>";
          "<leader>b" = "<cmd>Telescope buffers<CR>";
          "<leader>c" = "<cmd>Telescope git_bcommits<CR>";
          "<leader>g" = "<cmd>Telescope git_status<CR>";
          "<leader>d" = "<cmd>Telescope lsp_definitions<CR>";
          "<leader>R" = "<cmd>Telescope lsp_references<CR>";

          "<leader>a" = "<cmd>lua vim.lsp.buf.code_action()<CR>";
          "<leader>D" = "<cmd>lua vim.lsp.buf.declaration()<CR>";
          "<leader>h" = "<cmd>lua vim.lsp.buf.hover()<CR>";
          "<leader>r" = "<cmd>lua vim.lsp.buf.rename()<CR>";
          "<leader>e" = "<cmd>lua vim.diagnostic.open_float()<CR>";

          # resize windows with arrows
          "<C-Up>"    = "<cmd>resize -2<CR>";
          "<C-Down>"  = "<cmd>resize +2<CR>";
          "<C-Left>"  = "<cmd>vertical resize +2<CR>";
          "<C-Right>" = "<cmd>vertical resize -2<CR>";

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
          "<CS-c>" = "\\\"+y";
          "<CS-x>" = "\\\"+c";
          "<CS-v>" = "\\\"+p";

          # saving
          "<C-s>" = "<cmd>w<CR>";
        };
      in
        normal ++ vni;
  };
}
