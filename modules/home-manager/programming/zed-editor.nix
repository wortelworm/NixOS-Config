{
  lib,
  pkgs,
  wortel,
  ...
}: {
  # TODO:
  #   compitest
  #   Syntax highlighting within strings
  programs.zed-editor = {
    enable = true;
    extensions = [
      "html"
      "toml"
      "elixir"
      "nix"
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
          # It needs to be named 'haskell-language-server-wrapper', as the extension expects it to be installed using ghcup:
          #     https://github.com/zed-industries/zed/blob/main/extensions/haskell/src/haskell.rs
          # Unsure why specifing "$@" instaed of lsp does not work
          binary.path = lib.getExe (pkgs.writeShellScriptBin "haskell-language-server-wrapper" ''
            ${lib.getExe' pkgs.haskellPackages.haskell-language-server "haskell-language-server"} lsp
          '');
        };
      };
    };
  };
}
