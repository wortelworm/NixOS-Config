# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{lib, ...}: {
  wortel = {
    hostname = "wortelworm5";

    cosmic = true;
    nvidia = true;
    kanata.enable = true;

    onedrive = true;
    games = true;
    terminalFun = true;

    textEditors = {
      helix.enable = true;
    };

    programmingLanguages = {
      rust = true;
      typst = true;
      latex = true;
      cpp = true;
    };

    ensureInstalled.librariesWGPU = true;
  };

  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  # This is only here for dualbooting with windows
  time.hardwareClockInLocalTime = true;

  # Trying to fix podman issues
  users.users.wortelworm = {
    subUidRanges = [
      {
        count = 65536;
        startUid = 100000;
      }
    ];

    subGidRanges = [
      {
        count = 65536;
        startGid = 100000;
      }
    ];
  };

  # Trying to fix build warnings
  users.groups.uinput.gid = lib.mkForce 990;
  users.users.polkituser.uid = lib.mkForce 998;
  users.users.systemd-coredump.uid = lib.mkForce 996;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # version of default settings to use
  # CHECK RELEASE NOTES IF UPDATING
  system.stateVersion = "23.11"; # Did you read the comment?
}
