{
  inputs,
  lib,
  pkgs,
  wortel,
  ...
}: {
  # TODO: it would be nice to skip all the imports if nixvim not enabled
  imports =
    [
      inputs.nixvim.homeModules.nixvim
      ./language.nix
      ./running.nix
      ./shortcuts.nix
    ]
    ++ lib.optionals wortel.programmingLanguages.latex [./latex.nix];

  # TODO: check everything and make more languages optional
  config = lib.mkIf wortel.textEditors.nixvim {
    # config = {
    home.packages = [
      # used by telescope find_files and file_browser
      pkgs.fd
    ];

    # adds and configures neovim using
    # https://github.com/nix-community/nixvim

    # These are some misc thingies
    programs.nixvim = {
      enable = true;

      # TODO: What are these being used for?
      #       Why are they on by default?
      withRuby = false;
      withPython3 = true; # required by jukit

      colorschemes.onedark = {
        enable = true;
        settings.style = "darker";
      };

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

        # Lualine replaces this
        cmdheight = 0;
      };

      # Note on preformance stuff:
      # Its not needed for me so only adds complexity

      plugins = {
        web-devicons.enable = true;
        lualine.enable = true;
        comment.enable = true;
        nvim-autopairs.enable = true;
        diffview.enable = true;
        gitsigns.enable = true;
        hop.enable = true;

        neoscroll = {
          enable = true;
          settings.hide_cursor = false;
        };

        toggleterm = {
          enable = true;
          settings = {
            direction = "horizontal";
            size.__raw =
              # lua
              "function(_) return vim.o.lines * 0.5 end";
          };
        };

        # Used instead of netrw and telescope.file-browser
        yazi = {
          enable = true;
          settings.open_for_directories = true;
        };

        telescope = {
          enable = true;

          extensions = {
            # better selection ui, used for code actions
            ui-select.enable = true;
            fzf-native.enable = true;
          };
        };
      };
    };
  };
}
