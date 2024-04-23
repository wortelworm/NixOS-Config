{ ... }:

rec {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "wortelworm";
  home.homeDirectory = "/home/wortelworm";

  imports = [
    # all over the place, as I want to primaraly
    # organize by thing, not home/nixos
    # ../desktop/plasma-home.nix
    ../desktop/hyprland-home.nix
    ../programs/programming.nix
    ../programs/games.nix
    ../programs/misc.nix
  ];

  # manage plain files
  home.file = {

  };

  # environment variables
  home.sessionVariables = {
    # EDITOR = "vim";
    FLAKE = "/home/${home.username}/.dotfiles";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # version of default settings to use
  # CHECK RELEASE NOTES IF UPDATING
  home.stateVersion = "23.11";
}
