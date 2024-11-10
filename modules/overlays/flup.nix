{
  rustPlatform,
  fetchFromGitHub,
  ...
}:
rustPlatform.buildRustPackage {
  name = "flup";

  src = fetchFromGitHub {
    owner = "wortelworm";
    repo = "flup";
    # Just the initial commit for now
    rev = "1506d666f4525fd9ce8970e32cf9333ce138ccc7";
    hash = "sha256-FrQkRmobaXO7dr8M/S63zZaP/6TlG0GLXLicpLs2cpk=";
  };

  cargoHash = "sha256-K+oT89a2VxrEjthRaiTF2VKWKWG7HUB2uttJli/1GGw=";
}
