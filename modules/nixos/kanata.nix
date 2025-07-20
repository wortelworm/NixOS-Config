{config, lib, ...}: {
  services.kanata = lib.mkIf config.wortel.kanata.enable {
    enable = true;
    keyboards."regulars" = {
      devices = [
        "/dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-kbd"
        "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
      ];

      # TODO: create navigation layer. See also:
      #   https://colemakmods.github.io/ergonomic-mods/extend.html
      #   https://www.reddit.com/r/Colemak/comments/i5vrys/does_anybody_use_extend_layer_for_programming/

      config = ''
        (defalias
            tem (tap-hold-press 200 200 esc lmet)

            qrt (layer-switch  qwerty)
            col (layer-switch colemak)
        )

        (defsrc
          esc
          grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
          caps a    s    d    f    g    h    j    k    l    ;    '    ret
          lsft z    x    c    v    b    n    m    ,    .    /    rsft
          lctl lmet lalt           spc            ralt rmet cmp  rctl
        )

        (deflayer qwerty
          caps
          grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
          @tem a    s    d    f    g    h    j    k    l    ;    '    ret
          lsft z    x    c    v    b    n    m    ,    .    /    rsft
          lctl lmet lalt           spc            ralt rmet cmp  @col
        )

        (deflayer colemak
          caps
          grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab  q    w    f    p    g    j    l    u    y    ;    [    ]    \
          @tem a    r    s    t    d    h    n    e    i    o    '    ret
          lsft z    x    c    v    b    k    m    ,    .    /    rsft
          lctl lmet lalt           spc            ralt rmet cmp  @qrt
        )
      '';
    };
  };
}
