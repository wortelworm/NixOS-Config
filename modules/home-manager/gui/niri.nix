{
  lib,
  pkgs,
  ...
}: let
  # Synchronized between niri and noctalia for the initial login animation.
  # TODO: maybe also change default backdrop color?
  # background-color = "#404040"; # See comment in usage with noctalia
  background-color = "#000000";
in {
  # TODO niri:
  #
  # polkit agent (probably from cosmic)
  # steam is not scaled
  #   Did some digging, apparently wayland-satallite scales to the lowest scale of all current monitors
  #   Since my main is 200% and side is 100%, it looks incorrect...
  # steam notifications
  #   Maybe should search for niri docs on this?
  # color scheme
  #   Maybe use the noctalia things for this.
  # font?
  # Maybe look through the defaults of niri config once again.
  #   Maybe change some animations to be exponential?
  #
  #
  # TODO noctalia:
  # change the bars components, take a look at screenshots on noctalia website
  #   Maybe even add weather info
  #
  # Left and right mouse click in tray seems reversed?
  # Proper volume feedback.
  #   There is an 'enable sounds' option,
  #   but the sound feedback is way too quiet in comparison to elisa.
  #
  # Also:
  # create a derivation which takes the noctalia toml file and let's noctalia check it.
  # (do a grep on warnings and invert the error code)
  # Probably through own modules build on top of hjem.
  # Or even wrapping a noctalia package with configuration.
  #
  # testing brightness on second monitor
  # checking monitor layout editor

  # The configuration in nix is not available yet, for both niri and noctalia...
  xdg.configFile."niri/config.kdl".text = let
    noctalia-exe = "${lib.getExe pkgs.noctalia}";
    noctalia-call = "${noctalia-exe} msg";
  in
    # kdl
    ''
      input {
        keyboard {
          xkb {
            options "compose:ralt"
          }
          repeat-delay 300
          repeat-rate 40
        }
        touchpad {
          tap
          natural-scroll
        }
        warp-mouse-to-focus
        focus-follows-mouse max-scroll-amount="30%"
      }

      output "eDP-1" {
        // It defaults to 1.75 for some reason,
        // but the order of the monitors is actually correct!
        scale 2.0
      }

      layout {
        always-center-single-column
        background-color "${background-color}"
        gaps 4
        focus-ring {
          width 3
        }
      }

      // Noctalia includes bar, notifications, wallpaper, launcher, etc
      spawn-at-startup "${noctalia-exe}"

      // You can change the path where screenshots are saved.
      // A ~ at the front will be expanded to the home directory.
      // The path is formatted with strftime(3) to give you the screenshot date and time.
      screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

      prefer-no-csd

      xwayland-satellite {
        path "${lib.getExe pkgs.xwayland-satellite}"
      }

      window-rule {
          match app-id=r#"^org\.keepassxc\.KeePassXC$"#
          block-out-from "screencast"
      }

      // Suggested from noctalia
      window-rule {
        geometry-corner-radius 7
        clip-to-geometry true
      }

      // Floating Noctalia settings window.
      // window-rule {
      //   match app-id="dev.noctalia.Noctalia"
      //   open-floating true
      //   default-column-width { fixed 1080; }
      //   default-window-height { fixed 920; }
      // }

      // Noctalia background in backdrop
      layer-rule {
        match namespace="^noctalia-backdrop"
        place-within-backdrop true
      }

      hotkey-overlay {
        skip-at-startup
      }

      debug {
        // Allows notification actions and window activation from Noctalia.
        honor-xdg-activation-with-invalid-serial
      }

      // I want this to be more similar to cosmic, so I will overwrite everything
      binds {
        // Mod-Shift-/, which is usually the same as Mod-?,
        // shows a list of important hotkeys.
        Mod+Shift+Slash { show-hotkey-overlay; }

        Mod+D hotkey-overlay-title="Run an Application" { spawn-sh "${noctalia-call} panel-toggle launcher"; }
        Mod+S hotkey-overlay-title="Noctalia settings" { spawn-sh "${noctalia-call} panel-toggle control-center"; }
        //Mod+X hotkey-overlay-title="Session options..." { spawn-sh "${noctalia-call} panel-toggle        TODO      sessionMenu toggle"; }
        //Mod+V hotkey-overlay-title="Toggle bar visiblity" { spawn-sh "${noctalia-call} bar toggle"; }
        Mod+T hotkey-overlay-title="Open a Terminal: kitty" { spawn "kitty" "-1"; }
        Mod+B hotkey-overlay-title="Open a Browser: firefox" { spawn "firefox"; }

        Mod+W repeat=false { toggle-overview; }
        Mod+Q repeat=false { close-window; }

        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }

        // Applications such as remote-desktop clients and software KVM switches may
        // request that niri stops processing the keyboard shortcuts defined here
        // so they may, for example, forward the key presses as-is to a remote machine.
        // It's a good idea to bind an escape hatch to toggle the inhibitor,
        // so a buggy application can't hold your session hostage.
        //
        // The allow-inhibiting=false property can be applied to other binds as well,
        // which ensures niri always processes them, even when an inhibitor is active.
        //
        // Might want to not allow inhibiting on some focus switching bindings as well...
        Alt+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

        // The quit action will show a confirmation dialog to avoid accidental exits.
        Ctrl+Alt+Delete { quit; }
        Mod+Shift+Escape { quit; }

        // Powers off the monitors. To turn them back on, do any input like
        // moving the mouse or pressing any other key.
        Mod+Shift+P { power-off-monitors; }


        // "-l 1.0" limits the volume to 100%, maybe want the maximum to be 150% like in cosmic?
        // ALso, do I want to call these directly or instead through noctalia
        XF86AudioRaiseVolume  allow-when-locked=true { spawn-sh "${noctalia-call} volume-up"; }
        XF86AudioLowerVolume  allow-when-locked=true { spawn-sh "${noctalia-call} volume-down"; }
        XF86AudioMute         allow-when-locked=true { spawn-sh "${noctalia-call} volume-mute"; }
        //TODO
        //XF86AudioMicMute      allow-when-locked=true { spawn-sh "${noctalia-call} volume muteInput"; }

        XF86AudioPlay         allow-when-locked=true { spawn-sh "playerctl play-pause"; }
        XF86AudioStop         allow-when-locked=true { spawn-sh "playerctl stop"; }
        XF86AudioPrev         allow-when-locked=true { spawn-sh "playerctl previous"; }
        XF86AudioNext         allow-when-locked=true { spawn-sh "playerctl next"; }

        XF86MonBrightnessUp   allow-when-locked=true { spawn-sh "${noctalia-call} brightness-up"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn-sh "${noctalia-call} brightness-down"; }

        // Manipulating windows
        // Shift and Ctrl are swapped from the default layout
        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-or-workspace-down; }
        Mod+Up    { focus-window-or-workspace-up; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-or-workspace-down; }
        Mod+K     { focus-window-or-workspace-up; }
        Mod+L     { focus-column-right; }

        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Down  { move-window-down-or-to-workspace-down; }
        Mod+Shift+Up    { move-window-up-or-to-workspace-up; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+H     { move-column-left; }
        Mod+Shift+J     { move-window-down-or-to-workspace-down; }
        Mod+Shift+K     { move-window-up-or-to-workspace-up; }
        Mod+Shift+L     { move-column-right; }

        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }
        Mod+Shift+Home { move-column-to-first; }
        Mod+Shift+End  { move-column-to-last; }

        Mod+Ctrl+Left  { focus-monitor-left; }
        Mod+Ctrl+Down  { focus-monitor-down; }
        Mod+Ctrl+Up    { focus-monitor-up; }
        Mod+Ctrl+Right { focus-monitor-right; }
        Mod+Ctrl+H     { focus-monitor-left; }
        Mod+Ctrl+J     { focus-monitor-down; }
        Mod+Ctrl+K     { focus-monitor-up; }
        Mod+Ctrl+L     { focus-monitor-right; }

        Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
        Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

        // Alternatively, there are commands to move just a single window:
        // Mod+Shift+Ctrl+Left  { move-window-to-monitor-left; }
        // ...

        // And you can also move a whole workspace to another monitor:
        // Mod+Shift+Ctrl+Left  { move-workspace-to-monitor-left; }
        // ...

        Mod+Page_Down      { focus-workspace-down; }
        Mod+Page_Up        { focus-workspace-up; }
        Mod+U              { focus-workspace-down; }
        Mod+I              { focus-workspace-up; }
        Mod+Shift+Page_Down { move-column-to-workspace-down; }
        Mod+Shift+Page_Up   { move-column-to-workspace-up; }
        Mod+Shift+U         { move-column-to-workspace-down; }
        Mod+Shift+I         { move-column-to-workspace-up; }

        // Alternatively, there are commands to move just a single window:
        // Mod+Ctrl+Page_Down { move-window-to-workspace-down; }
        // ...

        Mod+Ctrl+Page_Down { move-workspace-down; }
        Mod+Ctrl+Page_Up   { move-workspace-up; }
        Mod+Ctrl+U         { move-workspace-down; }
        Mod+Ctrl+I         { move-workspace-up; }

        // You can bind mouse wheel scroll ticks using the following syntax.
        // These binds will change direction based on the natural-scroll setting.
        //
        // To avoid scrolling through workspaces really fast, you can use
        // the cooldown-ms property. The bind will be rate-limited to this value.
        // You can set a cooldown on any bind, but it's most useful for the wheel.
        Mod+WheelScrollDown       cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp         cooldown-ms=150 { focus-workspace-up; }
        Mod+Shift+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
        Mod+Shift+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

        Mod+WheelScrollRight       { focus-column-right; }
        Mod+WheelScrollLeft        { focus-column-left; }
        Mod+Shift+WheelScrollRight { move-column-right; }
        Mod+Shift+WheelScrollLeft  { move-column-left; }

        // Usually scrolling up and down with Shift in applications results in
        // horizontal scrolling; these binds replicate that.
        Mod+Ctrl+WheelScrollDown       { focus-column-right; }
        Mod+Ctrl+WheelScrollUp         { focus-column-left; }
        Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
        Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

        // Similarly, you can bind touchpad scroll "ticks".
        // Touchpad scrolling is continuous, so for these binds it is split into
        // discrete intervals.
        // These binds are also affected by touchpad's natural-scroll, so these
        // example binds are "inverted", since we have natural-scroll enabled for
        // touchpads by default.
        // Mod+TouchpadScrollDown { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02+"; }
        // Mod+TouchpadScrollUp   { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02-"; }

        // You can refer to workspaces by index. However, keep in mind that
        // niri is a dynamic workspace system, so these commands are kind of
        // "best effort". Trying to refer to a workspace index bigger than
        // the current workspace count will instead refer to the bottommost
        // (empty) workspace.
        //
        // For example, with 2 workspaces + 1 empty, indices 3, 4, 5 and so on
        // will all refer to the 3rd workspace.
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }

        // Alternatively, there are commands to move just a single window:
        // Mod+Ctrl+1 { move-window-to-workspace 1; }

        // Switches focus between the current and the previous workspace.
        // Mod+Tab { focus-workspace-previous; }

        // The following binds move the focused window in and out of a column.
        // If the window is alone, they will consume it into the nearby column to the side.
        // If the window is already in a column, they will expel it out.
        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }

        // Consume one window from the right to the bottom of the focused column.
        Mod+Comma  { consume-window-into-column; }
        // Expel the bottom window from the focused column to the right.
        Mod+Period { expel-window-from-column; }

        Mod+R { switch-preset-column-width; }
        // Cycling through the presets in reverse order is also possible.
        // Mod+R { switch-preset-column-width-back; }
        Mod+Shift+R { switch-preset-window-height; }
        Mod+Ctrl+R { reset-window-height; }
        Mod+M { maximize-column; }
        Mod+F { fullscreen-window; }

        // Expand the focused column to space not taken up by other fully visible columns.
        // Makes the column "fill the rest of the space".
        Mod+Ctrl+M { expand-column-to-available-width; }

        Mod+C { center-column; }

        // Center all fully visible columns on screen.
        Mod+Ctrl+C { center-visible-columns; }

        // Finer width adjustments.
        // This command can also:
        // * set width in pixels: "1000"
        // * adjust width in pixels: "-5" or "+5"
        // * set width as a percentage of screen width: "25%"
        // * adjust width as a percentage of screen width: "-10%" or "+10%"
        // Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
        // set-column-width "100" will make the column occupy 200 physical screen pixels.
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }

        // Finer height adjustments when in column with other windows.
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        // Move the focused window between the floating and the tiling layout.
        Mod+G       { toggle-window-floating; }
        Mod+Shift+G { switch-focus-between-floating-and-tiling; }

        // Toggle tabbed column display mode.
        // Windows in this column will appear as vertical tabs,
        // rather than stacked on top of each other.
        // Mod+S { toggle-column-tabbed-display; }

        // Actions to switch layouts.
        // Note: if you uncomment these, make sure you do NOT have
        // a matching layout switch hotkey configured in xkb options above.
        // Having both at once on the same hotkey will break the switching,
        // since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
        // Mod+Space       { switch-layout "next"; }
        // Mod+Shift+Space { switch-layout "prev"; }
      }
    '';

  # This config file is finally for v5 of noctalia.
  # To view the settings configured by noctalia, run:
  # `, noctalia config export full | bat -l toml`
  xdg.configFile."noctalia/settings.toml".source = (pkgs.formats.toml {}).generate "noctalia-settings.toml" {
    location.address = "Utrecht";

    theme.builtin = "Eldritch";
    backdrop.enabled = true;
    wallpaper = rec {
      # TODO: there seems to be a bug in noctalia with this fill_color.
      # It doesn't load this until: in monitor settings do eDP-1 fill color back and forth to 'Inherit'.
      # Should look it up if someone else has run into this in github.
      #
      # For now workaround by setting background-color to fully black, which is the default in noctalia.
      fill_color = background-color;
      transition_on_startup = true;
      directory = "/home/wortelworm/Config-NixOS/resources";
      default.path = "${directory}/wallpaper.png";
    };

    nightlight.enabled = true;
    shell = {
      clipboard_enabled = false;

      launcher = {
        sort_by_usage = false;

        providers = {
          session.global = true;
        };
      };
    };

    notification = {
      position = "bottom_right";
      history_retention_hours = 10;
    };

    bar.default = {
      auto_hide = true;
      reserve_space = false;
      show_on_workspace_switch = false;

      margin_ends = 0;
      radius_top_left = 0;
      radius_top_right = 0;

      dead_zone.actions.middle = "settings-open bar";

      start = [
        "launcher"
        "wallpaper"
        "workspaces"
        "media"
      ];

      end = [
        "tray"
        "notifications"
        "privacy"
        "network"
        "bluetooth"
        "volume"
        "input_volume"
        "brightness"
        "battery"
        "session"
      ];

      # TODO: test this out with a game
      layer = "overlay";
    };

    widget = {
      clock = {
        format = "{:%d %B, %H:%M}";
      };
      tray = {
        hidden = ["nm-applet"];
      };
      brightness = {
        show_label = false;
      };
      volume = {
        show_label = false;
      };
      input_volume = {
        show_label = false;
      };
      network = {
        show_label = false;
      };
      notifications = {
        hide_when_no_unread = true;
      };
      media = {
        hide_when_no_media = true;
      };
      privacy = {
        hide_inactive = true;
      };
      workspaces = {
        display = "none";
        hide_when_empty = true;
      };
    };
  };
}
