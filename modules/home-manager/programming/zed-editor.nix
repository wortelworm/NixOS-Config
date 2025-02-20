{
  lib,
  pkgs,
  wortel,
  ...
}: {
  # TODO:
  #   compitest
  #   Syntax highlighting within strings
  programs.zed-editor = lib.mkIf wortel.zed-editor {
    enable = true;
    extensions = [
      "nix"
      "toml"
      "nu"
      "html"
      "elixir"
      "haskell"
    ];
    userSettings = {
      vim_mode = true;
      assistant.enabled = false;
      hour_format = "hour24";
      calls.mute_on_join = true;

      # Is installed in ../../nixos/programs.nix
      # Patched font so that starship works
      terminal.font_family = "Hack Nerd Font";

      inlay_hints.enabled = true;

      languages = {
        Nix.language_servers = ["nixd" "!nil"];
      };

      lsp = {
        nixd = {
          binary.path = lib.getExe pkgs.nixd;
          settings.formatting.command = ["alejandra"];
        };
        rust-analyzer = {
          binary.path = lib.getExe pkgs.rust-analyzer;
          settings.check.command = "clippy";
        };
        elixir-ls = lib.mkIf wortel.beamLanguages {
          binary.path = lib.getExe pkgs.elixir-ls;
        };

        hls = {
          binary.path = lib.getExe pkgs.haskell-ghcup-lsp;
        };
      };
    };
  };
}
