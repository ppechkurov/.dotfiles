{ lib, pkgs, app_ids, ... }:
let
  mod = "Mod4";
  concatAttrs = lib.fold (x: y: x // y) { };
  tagBinds = concatAttrs (map (i: {
    "${mod}+${toString i}" = "workspace ${toString i}";
    "${mod}+Shift+${toString i}" = "move container to workspace ${toString i}";
  }) (lib.range 0 9));
in tagBinds // {
  "${mod}+Return" = "exec foot";
  "${mod}+dollar" = "exec scratch ${app_ids.scratchpad}";
  "${mod}+m" = "exec music ${app_ids.float_music} ncmpcpp";

  "${mod}+b" = "exec ${lib.getExe pkgs.chromium}";

  "${mod}+r" = "exec tofi-launcher";
  "${mod}+p" = "exec tofi-pass";
  "${mod}+c" = "exec tofi-calc";
  "${mod}+s" = "exec foot tofi-ssh";
  "${mod}+Shift+t" = "exec tofi-emoji";

  "XF86AudioMute" = "exec amixer sset Master toggle";
  "${mod}+F12" = "exec amixer sset Master 5%+";
  "${mod}+F11" = "exec amixer sset Master 5%-";
  "XF86AudioRaiseVolume" = "exec amixer sset Master 5%+";
  "XF86AudioLowerVolume" = "exec amixer sset Master 5%-";

  "${mod}+XF86AudioRaiseVolume" = "exec amixer sset Master 1%+";
  "${mod}+XF86AudioLowerVolume" = "exec amixer sset Master 1%-";

  "XF86AudioNext" = "exec ${lib.getExe pkgs.playerctl} next";
  "XF86AudioPrev" = "exec ${lib.getExe pkgs.playerctl} previous";
  "XF86AudioPlay" = "exec ${lib.getExe pkgs.playerctl} play-pause";

  "XF86MonBrightnessDown" = "exec ${lib.getExe pkgs.brightnessctl} s 5%-";
  "XF86MonBrightnessUp" = "exec ${lib.getExe pkgs.brightnessctl} s 5%+";

  "${mod}+XF86MonBrightnessDown" =
    "exec ${lib.getExe pkgs.brightnessctl} s 1%-";
  "${mod}+XF86MonBrightnessUp" = "exec ${lib.getExe pkgs.brightnessctl} s 1%+";

  "${mod}+d" = "kill";
  "${mod}+Shift+r" = "mode resize";
  "${mod}+q" = "mode quit";

  "${mod}+k" = "focus up";
  "${mod}+l" = "focus right";
  "${mod}+j" = "focus down";
  "${mod}+h" = "focus left";

  "${mod}+Up" = "focus up";
  "${mod}+Right" = "focus right";
  "${mod}+Down" = "focus down";
  "${mod}+Left" = "focus left";

  "${mod}+Shift+h" = "move left";
  "${mod}+Shift+j" = "move down";
  "${mod}+Shift+k" = "move up";
  "${mod}+Shift+l" = "move right";

  "${mod}+f" = "fullscreen";

  "${mod}+e" = "layout toggle split";
  "${mod}+Shift+space" = "floating toggle";
  "${mod}+space" = "focus mode_toggle";
  "${mod}+Shift+s" = "sticky toggle";
  "${mod}+a" = "focus parent";
  "${mod}+Shift+c" = "reload";
  "${mod}+Shift+q" = "exec tofi-powermenu";
}
