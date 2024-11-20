{
  inputs,
  lib,
  pkgs,
  wortel,
  ...
}: {
  imports =
    [
      inputs.nixvim.homeManagerModules.nixvim
      ./language.nix
      ./running.nix
      ./shortcuts.nix
    ]
    ++ lib.optionals wortel.latex [./latex.nix];

  home.packages = [
    # used by telescope find_files and file_browser
    pkgs.fd
  ];

  # adds and configures neovim using
  # https://github.com/nix-community/nixvim
  # todo: better indentation,

  # These are some misc thingies
  programs.nixvim = {
    enable = true;

    withRuby = false;

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
    };

    performance = {
      byteCompileLua.enable = true;
      # Might want to try to figure this out one day
      # Could make startup time faster
      # combinePlugins.enable = true;
    };

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
          size = 15;
        };
      };

      telescope = {
        enable = true;

        extensions = {
          # better selection ui, used for code actions
          ui-select.enable = true;
          fzf-native.enable = true;
          file-browser = {
            enable = true;
            settings.hijack_netrw = true;
          };
        };
      };
    };
  };
}
