{
  config,
  lib,
  pkgs,
  wortel,
  ...
}: let
  rust-path = "${config.home.homeDirectory}/Documents/Programming/rust";
  helix-path = "${rust-path}/helix-steel-event-system";
  steel-path = "${rust-path}/steel";
in {
  # Create symlinks so that if I want to use it I can
  # Installation steps for loacl helix build:
  # clone steel and helix from mattwparas
  # run cargo run --release in both
  # also run it in steel/crates/steel-language-server
  # Then run cargo run --release --package xtask -- code-gen

  programs.helix = {
    enable = true;

    # Language servers and stuff
    # Note that rust-analyzer is installed with rustup
    extraPackages = with pkgs; [
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

    package = lib.mkIf wortel.helix-local-build (pkgs.writeShellScriptBin "hx" ''
      export HELIX_RUNTIME="${helix-path}/runtime"
      ${helix-path}/target/release/hx "$@"
    '');

    # TODO: settings and language's using nix
  };

  # Steel and steel lsp can be added back later
  # home.packages = [
  #   (pkgs.writeShellScriptBin "steel" ''
  #     ${steel-path}/target/release/steel "$@"
  #   '')
  #   (pkgs.writeShellScriptBin "steel-language-server" ''
  #     ${steel-path}/target/release/steel-language-server "$@"
  #   '')
  # ];
}
