{
  rustPlatform,
  fetchFromGitHub,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "flup";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "wortelworm";
    repo = "flup";
    rev = "v${version}";
    hash = "sha256-96EAZ5CBIxx01VRpayXc2u48KkhHiC3TbmLGoMgVRH0=";
  };

  cargoLock.lockFile = "${src}/Cargo.lock";
}
