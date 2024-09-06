{ inputs, ... }:

{
  imports = [
    inputs.kmonad.nixosModules.default 
  ];

  services.kmonad = {
    enable = true;
    keyboards = {
      externalWirelessLogitec = {
        device = "/dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-kbd";
        defcfg = {
          enable = true;
          fallthrough = true;
          compose.key = null;
          allowCommands = false;
        };
        config = builtins.readFile ./kmonad.kbd;
      };

      # TODO: builtin platform keyboard
    };
  };
}
