{ ... }:
let browser = "firefox";
in {
  wayland.windowManager.hyprland.settings = {
    bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];

    bind = [
      "$mod SHIFT, E, exec, pkill Hyprland"
      "$mod SHIFT, C, exec, hyprctl reload && notify-send 'Hyprland reloaded'"
      "$mod SHIFT, Q, exec, tofi-powermenu"
      "$mod, B, exec, ${browser}"
      "$mod, Return, exec, foot --override colors.alpha=0.10"

      "$mod, C, exec, tofi-calc"
      "$mod, P, exec, tofi-pass"
      "$mod, R, exec, tofi-launcher"
      "$mod, S, exec, foot tofi-ssh"
      "$mod, V, exec, tofi-clip"
      "$mod Shift, T, exec, tofi-emoji"

      "$mod, Space, togglefloating"
      "$mod SHIFT, Space, pin"
      "$mod, F, fullscreen"
      "$mod, D, killactive"

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
      "$mod, dollar, resizewindowpixel, exact 80% 80%, class:scratch"
      "$mod, dollar, centerwindow"

      "$mod SHIFT, M, movetoworkspace, special:music"
      "$mod, M, togglespecialworkspace, music"
      "$mod, M, resizewindowpixel, exact 80% 80%, class:music"
      "$mod, M, centerwindow"

      '', Print, exec, grim -g "$(slurp)" - | satty --filename=-''
      "$mod SHIFT, R, submap, resize"
    ] ++ (
      # workspaces
      # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      builtins.concatLists (builtins.genList (x:
        let ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
        in [
          "$mod, ${ws}, workspace, ${toString (x + 1)}"
          "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
        ]) 10));

    binde = [
      "$mod, F11, exec, amixer sset Master 5%+"
      "$mod, F12, exec, amixer sset Master 5%-"
      ",XF86AudioRaiseVolume, exec, amixer sset Master 5%+"
      ",XF86AudioLowerVolume, exec, amixer sset Master 5%-"
    ];
  };
}
