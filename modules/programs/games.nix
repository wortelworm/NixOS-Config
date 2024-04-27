{ pkgs, ... }:

{
  home.packages = with pkgs; [
    prismlauncher
  ];

  # steam is always installed currently...
  # note: to make it scale launch program with argument `-forcedesktopscaling 2`
  # this is not working yet...
  # xdg.desktopEntries = {
  #   steam = {
  #     name = "Steam";
  #     icon = "steam";
  #     exec = "steam -forcedesktopscaling 2 %U";
  #     type = "Application";
  #     terminal = false;
  #     categories = [ "Network" "FileTransfer" "Game" ];
  #     mimeType = [ "x-scheme-handler/steam" "x-scheme-handler/steamlink"];
  #     comment = "Application for managing and playing games on Steam";
  #     # by default there are also actions, by I dont use them
  #   };
  # };
}