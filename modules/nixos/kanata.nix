{
  config,
  lib,
  ...
}: {
  services.kanata = lib.mkIf config.wortel.kanata {
    enable = true;

    # Intercept all devices with this config
    keyboards."regulars" = {
      # TODO: I'm not entirely happy with this just yet...
      # navigation layer add Home/End, Tab, ..
      # home row reduce time?

      # For an overview of features, see:
      # https://jtroo.github.io/config.html
      #
      # Note that by pressing and holding Left Control, Space, Escape, kanata will exit
      # Restart using `systemctl start kanata-[keyboard name].service`
      extraDefCfg = ''
        process-unmapped-keys yes
      '';

      config = ''
        (defalias
            tem (tap-hold-press 200 200 esc lmet)
            nav (layer-while-held navigation)

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

        (defalias
            aa (tap-hold 200 200 a lmet)
            rr (tap-hold 200 200 r lalt)
            ss (tap-hold 200 200 s lsft)
            tt (tap-hold 200 200 t lctl)

            nn (tap-hold 200 200 n rctl)
            ee (tap-hold 200 200 e rsft)
            ii (tap-hold 200 200 i ralt)
            oo (tap-hold 200 200 o rmet)
        )

        (deflayer colemak
          caps
          grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab  q    w    f    p    g    j    l    u    y    ;    [    ]    \
          esc  @aa  @rr  @ss  @tt  d    h    @nn  @ee  @ii  @oo  '    ret
          lsft z    x    c    v    b    k    m    ,    .    /    rsft
          lctl lmet @nav           spc            ralt rmet cmp  @qrt
        )

        (deflayer navigation
          _
          _    _    _    _    _    _    _    _    _    _    _    _    _    _
          _    _    _    _    _    _    _    _    _    _    _    _    _    _
          _    lmet lalt lsft lctl _    left down up  right _    _    _
          _    _    _    _    _    _    _    _    _    _    _    _
          _    _    _              _              _    _    _    _
        )
      '';
    };
  };
}
