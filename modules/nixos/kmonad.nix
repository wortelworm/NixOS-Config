{inputs, ...}: {
  imports = [
    inputs.kmonad.nixosModules.default
  ];

  services.kmonad = {
    enable = true;
    keyboards =
      builtins.mapAttrs (name: value: {
        # Settings are the same for all keyboards
        device = value;
        defcfg = {
          enable = true;
          fallthrough = true;
          compose.key = null;
          allowCommands = false;
        };
        config = builtins.readFile ./kmonad.kbd;
      }) {
        externalWirelessLogitec = "/dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-kbd";
        builtinPlatform = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
      };
  };
}
