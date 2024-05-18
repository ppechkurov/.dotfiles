{ lib, pkgs, app_ids, ... }:
let
  mod = "Mod4";
  concatAttrs = lib.fold (x: y: x // y) { };
  tagBinds = concatAttrs (map (i: {
    "${mod}+${toString i}" = "workspace ${toString i}";
    "${mod}+Shift+${toString i}" = "move container to workspace ${toString i}";
  }) (lib.range 0 9));
in tagBinds // {
  "${mod}+Shift+Return" = "exec footclient";
  "${mod}+Return" = "exec scratch ${app_ids.scratchpad}";
  "${mod}+m" = "exec music ${app_ids.float_music} ncmpcpp";

  "${mod}+b" = "exec ${lib.getExe pkgs.chromium}";
  "${mod}+r" = "exec tofi-launcher";

  "${mod}+p" = "exec tofi-pass";
  "${mod}+t" = "exec tofi-calc";
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
  "${mod}+h" = "focus left";
  "${mod}+j" = "focus down";
  "${mod}+k" = "focus up";
  "${mod}+l" = "focus right";
  "${mod}+Shift+h" = "move left";
  "${mod}+Shift+j" = "move down";
  "${mod}+Shift+k" = "move up";
  "${mod}+Shift+l" = "move right";
  "${mod}+e" = "layout toggle split";
  "${mod}+f" = "fullscreen";
  "${mod}+space" = "floating toggle";
  "${mod}+Shift+s" = "sticky toggle";
  "${mod}+Shift+space" = "focus mode_toggle";
  "${mod}+a" = "focus parent";
  "${mod}+Shift+c" = "reload";
  "${mod}+Shift+q" = "exec tofi-powermenu";
}
