{
  flake.modules.nixos.greetd = { config, pkgs, ... }: {
    services.greetd.enable = true;
    services.greetd.settings = {
      default_session = {
        command = # bash
          ''
            ${pkgs.tuigreet}/bin/tuigreet \
              --time \
              --remember \
              --remember-session \
              --cmd niri \
              --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions
          '';
      };
    };

    # this is a life saver.
    # literally no documentation about this anywhere.
    # might be good to write about this...
    # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
    # found [here](https://github.com/sjcobb2022/nixos-config/blob/main/hosts/common/optional/greetd.nix)
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam on screen
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
