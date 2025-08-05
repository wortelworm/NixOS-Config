{pkgs, ...}: {
  home.packages = with pkgs; [
    # TODO: figure out how to make blender use nvidia drivers
    # blender

    # remote desktop
    remmina
  ];

  programs.ssh = {
    enable = true;
    addKeysToAgent = "confirm";

    # Sources:
    #   Github: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints
    userKnownHostsFile = "${pkgs.writeText "known_hosts" ''
      github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
      git.science.uu.nl ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPEbg2mBaox7ZwGa/0o+JM+EUWPnPtknfCltzm1Xap9x
    ''}";
  };
}
