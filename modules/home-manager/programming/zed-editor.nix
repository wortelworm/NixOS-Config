{pkgs, ...}: {
  # TODO:
  #   compitest
  #   terminal patched font
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

      theme = {
        mode = "system";
        dark = "One Dark";
        light = "One Dark";
      };

      # Is installed in ../../nixos/programs.nix
      # Patched font so that starship works
      terminal.font_family = "Hack Nerd Font";

      inlay_hints.enabled = true;

      languages = {
        Nix.language_servers = ["nixd" "!nil"];
      };

      lsp = {
        nixd = {
          binary.path = "${pkgs.nixd}/bin/nixd";
          settings.formatting.command = ["alejandra"];
        };
        rust-analyzer = {
          binary.path = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          settings.check.command = "clippy";
        };
        elixir-ls = {
          binary.path = "${pkgs.elixir-ls}/bin/elixir-ls";

          settings = {
            # Idk if this works
            dialyzerEnabled = true;
          };
        };

        # TODO: not working yet
        hls = {
          binary.path = "${pkgs.haskellPackages.haskell-language-server}/bin/haskell-language-server";
        };
      };
    };
  };
}
