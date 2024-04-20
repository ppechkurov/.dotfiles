{ pkgs, lib, ... }:
{
  home = {
    packages = with pkgs; [ 
      wf-recorder
      wl-clipboard
      xdg-utils
      playerctl
    ];

    # sessionVariables = {
    #   NIXOS_OZONE_WL = "1";
    #   DISABLE_QT5_COMPAT = "0";
    #   QT_QPA_PLATFORM = "wayland;xcb";
    #   GDK_BACKEND = "wayland";
    #   MOZ_ENABLE_WAYLAND = "1";
    #   XDG_SESSION_TYPE = "wayland";
    #   SDL_VIDEODRIVER = "wayland";
    #   CLUTTER_BACKEND = "wayland";
    # };
  };

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    extraSessionCommands = ''
      export XDG_CURRENT_DESKTOP=sway;
    '';
    wrapperFeatures.gtk = true;
    config = {
      bindkeysToCode = true;

      window = {
        titlebar = false;
        border = 2;
      };

      gaps = {
        inner = 10;
      };

      input = {
        "type:keyboard" = {
          xkb_layout = "us,ru";
          xkb_variant = "real-prog-dvorak,";
          xkb_options = "grp:alt_shift_toggle"; # switch layout
          repeat_delay = "250";
          repeat_rate = "45";
        };
        "type:mouse" = {
          dwt = "disabled";
          accel_profile = "flat";
        };
      };

      bars = [{
        position = "top";
        command = "waybar";
      }];

      floating = {
        criteria = [ { app_id = "float_htop"; } ];
        border = 2;
      };

      defaultWorkspace = "workspace 1";
      keybindings = let
        mod = "Mod4";
        concatAttrs = lib.fold (x: y: x // y) { };
        tagBinds = concatAttrs (map (i: {
          "${mod}+${toString i}" = "exec 'swaymsg workspace ${toString i}'";
          "${mod}+Shift+${toString i}" =
            "exec 'swaymsg move container to workspace ${toString i}'";
        }) (lib.range 0 9));
      in tagBinds // {
        "${mod}+Return" = "exec footclient";
        "${mod}+b" = "exec ${lib.getExe pkgs.chromium}";
        "${mod}+r" = "exec wofi";

        "XF86AudioMute" = "exec amixer sset Master toggle";
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
        "${mod}+XF86MonBrightnessUp" =
          "exec ${lib.getExe pkgs.brightnessctl} s 1%+";

        "${mod}+q" = "kill";
        "${mod}+Shift+r" = ''mode "resize"'';
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
        "${mod}+Shift+q" = "exit";
      };
      seat = { "*".hide_cursor = "when-typing enable"; };
      output = {
        "Virtual-1" = {
          # mode = "1920x1080@59.963Hz";
          mode = "1680x1050@59.954Hz";
        };
      };
    };
  };
}
