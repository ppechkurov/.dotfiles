{ config, pkgs, lib, osConfig, ... }: {
  home.packages = with pkgs; [ wf-recorder wl-clipboard xdg-utils playerctl ];

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = "export XDG_CURRENT_DESKTOP=sway;";

    config = let scratchpad_app_id = "scratch_term";
    in {
      bindkeysToCode = true;

      window = {
        border = 2;
        titlebar = false;
        commands = [{
          command = "move container to scratchpad";
          criteria.app_id = "${scratchpad_app_id}";
        }];
      };

      startup = [
        { # foot scratchpad
          command = let
            opacity = ".82";
            cwd = "${config.home.homeDirectory}/.dotfiles";
          in ''
            exec foot \
              --app-id ${scratchpad_app_id} \
              --override colors.alpha=${opacity} \
              --working-directory ${cwd}
          '';
        }
        { command = "exec telegram-desktop"; }
      ];

      gaps = { inner = 10; };

      input = import ./input.nix;

      bars = [{
        position = "top";
        command = "waybar";
      }];

      floating = {
        modifier = "Mod4";
        criteria = [
          { class = "float"; }
          { app_id = "float_htop"; }
          { app_id = "pavucontrol"; }
        ];
        border = 2;
      };

      defaultWorkspace = "workspace 1";
      workspaceAutoBackAndForth = true;

      assigns = {
        "1" = [ { app_id = "^footclient$"; } { app_id = "^foot$"; } ];
        "2" = [{ app_id = "^chromium-browser$"; }];
        "4" = [{ app_id = "^org.telegram.desktop$"; }];
      };

      keybindings = import ./keybindings.nix {
        inherit lib;
        inherit pkgs;
      };

      seat = { "*".hide_cursor = "when-typing enable"; };
      output = osConfig.monitor;
    };
  };
}
