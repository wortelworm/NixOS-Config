{
  config,
  lib,
  pkgs,
  wortel,
  ...
}: let
  # Language servers and stuff
  # Note that rust-analyzer is installed with rustup
  runtimeInputs = with pkgs; [
    taplo # TODO: validation of Cargo.toml schema?
    nixd
    haskell-ghcup-lsp
    texlab
    tinymist # typst
    wgsl-analyzer

    # C-sharp lsp and dap
    omnisharp-roslyn
    netcoredbg
  ];
in
  if !wortel.helix
  then let
    rust = "${config.home.homeDirectory}/Documents/Programming/rust";
    helix = "${rust}/helix-steel-event-system";
    steel = "${rust}/steel";
  in {
    # Create symlinks so that if I want to use it I can
    # Installation steps:
    # clone steel and helix from mattwparas
    # run cargo run --release in both
    # also run it in steel/crates/steel-language-server
    # Then run cargo run --release --package xtask -- code-gen

    programs.helix = {
      enable = true;
      extraPackages = runtimeInputs;

      package = pkgs.writeShellScriptBin "hx" ''
        export HELIX_RUNTIME="${helix}/runtime"
        ${helix}/target/release/hx "$@"
      '';
    };

    home.packages = [
      (pkgs.writeShellScriptBin "steel" ''
        ${steel}/target/release/steel "$@"
      '')
      (pkgs.writeShellScriptBin "steel-language-server" ''
        ${steel}/target/release/steel-language-server "$@"
      '')
    ];
  }
  else {
    # Do installation of helix using nix
    home.packages = with pkgs; [
      steel
    ];
    # Note that this relies on the experimental steel plugin system
    programs.helix = {
      enable = true;
      extraPackages = runtimeInputs;
      settings = {
        theme = "tokyonight";
        editor = {
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          line-number = "relative";
          soft-wrap.enable = true;
        };
        keys.normal = {
          "C-g" = [":new" ":insert-output lazygit" ":buffer-close!" ":redraw" ":reload-all"];
          "C-S-i" = ":format";
        };
      };

      # For all default settings, see:
      #     https://github.com/helix-editor/helix/blob/master/languages.toml
      languages = {
        language-server = {
          # Make sure that rust-analayzer component is present, using:
          # `rustup component add rust-analyzer`
          rust-analyzer.config.check.command = "clippy";

          steel-language-server.command = lib.getExe' pkgs.steel-lsp "steel-language-server";
        };

        language = [
          {
            name = "scheme";
            # TODO
            # formatter = {
            #   command = "raco";
            #   args = ["fmt" "-i"];
            # }
            language-servers = ["steel-language-server"];
          }
          {
            name = "nix";
            formatter.command = "alejandra";
            language-servers = ["nixd"];
          }
        ];
      };
    };
  }
