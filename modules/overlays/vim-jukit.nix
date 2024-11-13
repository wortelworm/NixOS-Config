{
  pkgs,
  fetchFromGitHub,
  ...
}:
pkgs.vimUtils.buildVimPlugin {
  pname = "vim-jukit";
  version = "1.4.1";
  src = fetchFromGitHub {
    owner = "luk400";
    repo = "vim-jukit";
    rev = "v1.4.1";
    hash = "sha256-vGIHNfecJSF0tL3lbIwO7vbrU/WQMkUKRG+G3bLNT9g=";
  };
  meta.homepage = "https://github.com/luk400/vim-jukit";
}
