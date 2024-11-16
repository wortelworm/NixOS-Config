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
    rev = "22c1bd6d086d3919e0f5c944d122004407df6d07";
    hash = "sha256-gyyhkcgw1H7yUAGin57XUHbLeLm50kYHFHkt2Cxe6OI=";
  };

  cargoHash = "sha256-K+oT89a2VxrEjthRaiTF2VKWKWG7HUB2uttJli/1GGw=";
}
