{ lib, pkgs, ... }:
[
  "$mod SHIFT, E, exec, pkill Hyprland"
  "$mod SHIFT, C, exec, hyprctl reload && notify-send 'Hyprland reloaded'"
  "$mod SHIFT, Q, exec, tofi-powermenu"
  "$mod, B, exec, chromium"
  "$mod, Return, exec, foot --override colors.alpha=0.10"

  "$mod, Space, togglefloating"
  "$mod, F, fullscreen"
  "$mod, D, killactive"

  ",XF86AudioMute, exec, amixer sset Master toggle"
  "$mod, F12, exec, amixer sset Master 5%+"
  "$mod, F11, exec, amixer sset Master 5%-"
  ",XF86AudioRaiseVolume, exec, amixer sset Master 5%+"
  ",XF86AudioLowerVolume, exec, amixer sset Master 5%-"

  "$mod, XF86AudioRaiseVolume, exec, amixer sset Master 1%+"
  "$mod, XF86AudioLowerVolume, exec, amixer sset Master 1%-"

  ",XF86AudioNext, exec, ${lib.getExe pkgs.playerctl} next"
  ",XF86AudioPrev, exec, ${lib.getExe pkgs.playerctl} previous"
  ",XF86AudioPlay, exec, ${lib.getExe pkgs.playerctl} play-pause"

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

  "$mod SHIFT, dollar, movetoworkspace, special:scratch"
  "$mod, dollar, togglespecialworkspace, scratch"
  "$mod, dollar, resizeactive, exact 80% 80%"
  "$mod, dollar, centerwindow"

  "$mod SHIFT, M, movetoworkspace, special:music"
  "$mod, M, togglespecialworkspace, music"
  "$mod, M, resizeactive, exact 80% 80%"
  "$mod, M, centerwindow"

  ", Print, exec, grimblast copy area"
] ++ (
  # workspaces
  # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
  builtins.concatLists (builtins.genList (x:
    let ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
    in [
      "$mod, ${ws}, workspace, ${toString (x + 1)}"
      "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
    ]) 10))
