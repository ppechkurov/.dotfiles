{ config, pkgs, lib, osConfig, ... }: {
  home.packages = with pkgs; [ wf-recorder wl-clipboard xdg-utils playerctl ];

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = "export XDG_CURRENT_DESKTOP=sway;";

    config = let
      app_ids = {
        scratchpad = "scratch_term";
        float_music = "float_music";
      };
    in {
      bindkeysToCode = true;

      window = {
        border = 2;
        titlebar = false;
        commands = with app_ids; [
          {
            command = "move container to scratchpad";
            criteria.app_id = "${scratchpad}";
          }
          {
            command = "resize set width 80ppt height 80ppt";
            criteria.app_id = "${float_music}";
          }
        ];
      };

      startup = [
        { # foot scratchpad
          command = let
            opacity = ".82";
            cwd = "${config.home.homeDirectory}/.dotfiles";
          in ''
            foot \
              --app-id ${app_ids.scratchpad} \
              --override colors.alpha=${opacity} \
              --working-directory ${cwd}
          '';
        }
        { command = "sleep 2 && telegram-desktop"; }
      ];

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
        criteria = with app_ids; [
          { class = "float"; }
          { app_id = "float_htop"; }
          { app_id = "${float_music}"; }
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
