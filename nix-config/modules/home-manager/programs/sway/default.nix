{ pkgs, lib, osConfig, ... }:
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

    extraConfig = "workspace 1";

    config = {
      bindkeysToCode = true;

      window = {
        border = 3;
        titlebar = false;
        commands = with app_ids; [
          {
            criteria.app_id = "${float_music}";
            command = "move position center,resize set 82ppt 51ppt";
          }
          {
            criteria.app_id = "flameshot";
            command = ''
              border pixel 0,\
                floating enable,\
                fullscreen disable,\
                move absolute position 0 0'';
          }
        ];
      };

      startup = with app_ids; [
        # no tray icon without sleep
        { command = "sleep 2 && telegram-desktop"; }
        { command = "scratch ${scratchpad}"; }
        { command = "scratch ${scratchpad}"; }
        { command = "wl-paste --type=text --watch cliphist store"; }
      ];

      focus.newWindow = "urgent";
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
          { app_id = "${app_ids.scratchpad}"; }
          { app_id = "^float_"; }
          { app_id = "mpv"; }
          { app_id = "pavucontrol"; }
        ];
        border = 2;
      };

      defaultWorkspace = "workspace 7";
      workspaceOutputAssign = import ./workspace-output-assign.nix;

      assigns = {
        "4" = [{ app_id = "^org.telegram.desktop$"; }];
        "7" = [{ app_id = "^chromium-browser$"; }];
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
