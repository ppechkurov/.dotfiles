{ config, pkgs, lib, osConfig, ... }:
let
  app_ids = {
    scratchpad = "scratch_term";
    float_music = "float_music";
  };
  scratch =
    pkgs.writeScriptBin "scratch" (builtins.readFile ./scripts/scratch.sh);
  music = pkgs.writeScriptBin "music" (builtins.readFile ./scripts/music.sh);
in {
  home.packages = with pkgs; [
    playerctl
    wf-recorder
    wl-clipboard
    xdg-utils
    scratch
    music
  ];

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = "export XDG_CURRENT_DESKTOP=sway;";

    config = {
      bindkeysToCode = true;

      window = {
        border = 3;
        titlebar = false;
        commands = with app_ids; [{
          criteria.app_id = "${float_music}";
          command = "move position center,resize set 82ppt 51ppt";
        }];
      };

      startup = [{
        # no tray icon without sleep
        command = "sleep 2 && telegram-desktop";
      }];

      # modes = {
      #   quit = {
      #     q = ''exec notify-send "quit"'';
      #     Escape = "mode default";
      #   };
      # };

      gaps = { inner = 10; };

      input = import ./input.nix;

      bars = [{
        position = "top";
        command = "waybar";
      }];

      floating = {
        modifier = "Mod4";
        criteria = [
          { app_id = "^float_"; }
          { app_id = "${app_ids.scratchpad}"; }
          { app_id = "pavucontrol"; }
        ];
        border = 2;
      };

      defaultWorkspace = "workspace 1";

      assigns = {
        "1" = [ { app_id = "^footclient$"; } { app_id = "^foot$"; } ];
        "2" = [{ app_id = "^chromium-browser$"; }];
        "4" = [{ app_id = "^org.telegram.desktop$"; }];
      };

      keybindings = import ./keybindings.nix {
        inherit lib;
        inherit pkgs;
        inherit app_ids;
      };

      seat = { "*".hide_cursor = "when-typing enable"; };
      output = osConfig.monitor;
    };
  };
}
