{...}: {
  imports = [
    ./yazi.nix
    ./funs.nix
  ];

  # Nushell is so much better than bash!!!!
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
  };

  # Automaticly adds completions for some many programs
  # TODO: proper look at autocompletion again
  programs.carapace.enable = true;

  # Database location: $XDG_DATA_HOME/zoxide/db.zo
  # Bash and nushell integration is enabled by default in home-manager
  programs.zoxide.enable = true;

  # TODO: find a good way of having a terminal with helix?
  programs.zellij.enable = true;

  # Replacing default bash/nushell prompt
  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };
}
