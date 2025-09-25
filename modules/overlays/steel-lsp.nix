{
  fetchFromGitHub,
  rustPlatform,
  ...
}: let
  repo = fetchFromGitHub {
    owner = "mattwparas";
    repo = "steel";
    rev = "785312ab654d47dd87c5a2b7a137e9fd9e644346";
    hash = "sha256-vrJlFLkH/2JYPvHWZiNHETMGUsMs0iTzxJ2hKk3rsKQ=";
  };
in
  rustPlatform.buildRustPackage {
    pname = "steel-lsp";
    version = "git";
    src = repo;
    buildAndTestSubdir = "crates/steel-language-server";
    cargoLock.lockFile = "${repo}/Cargo.lock";
    doCheck = false;
    doInstallCheck = false;
  }
