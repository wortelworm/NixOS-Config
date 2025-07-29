{
  lib,
  pkgs,
  pkgs-unstable,
  wortel,
  ...
}: let
  lang = wortel.programmingLanguages;
in {
  # TODO:
  #   autoformat?
  #   typst
  #   Syntax highlighting for nix files
  #   Fix icons in terminal not using font or something
  #   Highlight TODO's
  #   tabbing through open files (maybe change something in kanata as well)
  #   compitest
  #   Add CodeLLDB for rust debugging
  programs.zed-editor = lib.mkIf wortel.textEditors.zed-editor {
    enable = true;

    package = pkgs-unstable.zed-editor;

    extensions =
      [
        "material-icon-theme"
        "nix"
        "nu"
      ]
      ++ lib.optionals lang.rust [
        "toml"
      ]
      ++ lib.optionals lang.haskell [
        "haskell"
      ]
      ++ lib.optionals lang.beam [
        "elixir"
      ];

    userSettings = {
      # TODO: helix mode?
      # Maybe just use the default zed mode with homemods instead?
      # vim_mode = true;

      # For now, testing
      # agent.enabled = false;
      # features.edit_prediction_provider = "none";

      # TODO: whenever 0.197 is out on unstable nix, use this option instead
      # disable_ai = true;

      hour_format = "hour24";
      calls.mute_on_join = true;

      terminal = {
        # Is installed in ../../nixos/programs.nix
        # Patched font so that starship works
        # Note that the buffer font already has ligatures and such
        font_family = "JetBrainsMono Nerd Font";

        # By default it uses bash
        shell.program = "nu";
      };

      icon_theme = "Material Icon Theme";

      inlay_hints.enabled = true;

      languages = {
        Nix.language_servers = ["nixd" "!nil"];
      };

      lsp = {
        rust-analyzer = lib.mkIf lang.rust {
          # This should by installed via rustup,
          # to match the way helix works
          binary.path = "rust-analyzer";

          settings.check.command = "clippy";
        };
        nixd = {
          binary.path = lib.getExe pkgs.nixd;
          settings.formatting.command = ["alejandra"];
        };
        elixir-ls = lib.mkIf lang.beam {
          binary.path = lib.getExe pkgs.elixir-ls;
        };
        hls = lib.mkIf lang.haskell {
          binary.path = lib.getExe pkgs.haskell-ghcup-lsp;
        };
      };
    };
  };
}
