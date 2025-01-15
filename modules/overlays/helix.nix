prev: {
  fetchFromGitHub,
  pkgs,
  rustPlatform,
  ...
}:
# This fork includes the experimental plugin system using steel
# Revision is of branch 'steel-event-system' on 2025-01-11
rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "unstable-steel";

  doCheck = false;
  doInstallCheck = false;

  # The release tarball includes source code for the tree-sitter grammars,
  # which is not ordinarily part of the repository.
  #
  # I hope im not gonna miss them
  src = fetchFromGitHub {
    owner = "mattwparas";
    repo = "helix";
    rev = "a9d5557a3b3c11767432bdacd36ccb3bea02bfa5";
    hash = "sha256-o+LmzQToDudSGrB1U7MaYrwt7soc+TLNV7rKtlitgN4=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  nativeBuildInputs = with pkgs; [
    git
    installShellFiles
  ];

  env = {
    # disable fetching and building of tree-sitter grammars in the helix-term build.rs
    # Found this in the build of 'evil-helix'
    HELIX_DISABLE_AUTO_GRAMMAR_BUILD = "1";

    HELIX_DEFAULT_RUNTIME = "${placeholder "out"}/lib/runtime";
  };

  # this copies tree-sitter grammars from helix package
  # TODO: build it from source instead
  postInstall = ''
    mkdir -p $out/lib
    cp -r runtime $out/lib

    cp -r ${prev.helix}/lib/runtime/grammars/* $out/lib/runtime/grammars/

    installShellCompletion contrib/completion/hx.{bash,fish,zsh}
    mkdir -p $out/share/{applications,icons/hicolor/256x256/apps}
    cp contrib/Helix.desktop $out/share/applications
    cp contrib/helix.png $out/share/icons/hicolor/256x256/apps
  '';
}
