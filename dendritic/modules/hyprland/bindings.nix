{
  flake.modules.homeManager.hyprland = { pkgs, lib, ... }:
    let browser = "firefox";
    in {
      wayland.windowManager.hyprland.settings = {
        "$mod" = "SUPER";
        "$ipc" = "noctalia-shell ipc call";

        bindm =
          [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];

        bind = [
          "$mod SHIFT, E, exec, pkill Hyprland"
          "$mod SHIFT, C, exec, hyprctl reload && ${pkgs.libnotify}/bin/notify-send 'Hyprland reloaded'"
          "$mod SHIFT, Q, exec, $ipc sessionMenu toggle"
          "$mod, B, exec, ${browser}"
          "$mod, Return, exec, foot --override colors.alpha=0.10"

          "$mod, C, exec, tofi-calc"
          "$mod, P, exec, tofi-pass"
          "$mod, comma, exec, $ipc launcher settings"
          "$mod, R, exec, $ipc launcher toggle"
          "$mod, V, exec, $ipc launcher clipboard"

          "$mod Shift, T, exec, tofi-emoji"

          "$mod, Space, togglesplit"
          "$mod SHIFT, Space, togglefloating"
          "$mod ALT, Space, pin"
          "$mod, F, fullscreen"
          "$mod, Q, killactive"

          # move focus
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"

          # move windows
          "$mod SHIFT, h, movewindow, l"
          "$mod SHIFT, l, movewindow, r"
          "$mod SHIFT, k, movewindow, u"
          "$mod SHIFT, j, movewindow, d"

          # '', Print, exec, grim -g "$(slurp)" - | satty --filename=-''
          ", Print, exec, flameshot gui"
          "$mod SHIFT, R, submap, resize"
        ] ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (x:
            let
              ws = let c = (x + 1) / 10;
              in builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]) 10));

        bindl = [
          ",XF86AudioMute, exec, $ipc volume muteOutput"
          ",XF86AudioNext, exec, $ipc media next"
          ",XF86AudioPrev, exec, $ipc media previous"
          ",XF86AudioPlay, exec, $ipc media playPause"
          ",XF86Tools, exec, jellyfin-desktop"

          ",XF86AudioNext, exec, $ipc media next"
          ",XF86AudioPrev, exec, $ipc media previous"
          ",XF86AudioPlay, exec, $ipc media playPause"
          ",XF86Tools, exec, jellyfin-desktop"
        ];

        # volume
        binde = [
          "$mod, F11, exec, $ipc volume increase"
          "$mod, F12, exec, $ipc volume decrease"
          ",XF86AudioRaiseVolume, exec, $ipc volume increase"
          ",XF86AudioLowerVolume, exec, $ipc volume decrease"
        ];
      };
    };
}
