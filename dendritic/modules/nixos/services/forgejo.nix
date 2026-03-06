{ self, ... }:
let
  dns = self.globals.dns.forgejo;
  cleanupService = "forgejo-dump-cleanup";
in {
  flake.modules.nixos.forgejo = { pkgs-unstable, config, ... }: {
    environment.systemPackages = [ pkgs-unstable.forgejo ];

    services.forgejo.enable = true;
    services.forgejo = {
      package = pkgs-unstable.forgejo;
      dump.enable = true;
      # stateDir = "/home/forgejo/data"; # this doesn't work at the moment
      settings = {
        service.DISABLE_REGISTRATION = true;
        openid.ENABLE_OPENID_SIGNIN = false;
        server = { ROOT_URL = "https://${dns}"; };
        "git.timeout" = {
          MIGRATE = 4200;
          MIRROR = 4200;
          CLONE = 4200;
          PULL = 4200;
        };
      };
    };

    systemd.services.${cleanupService} = {
      enable = true;
      description = "Clean up forgejo dumps";
      serviceConfig = {
        Type = "oneshot";
        User = "forgejo";
      };
      path = [ ];

      script = # bash
        ''
          rm -rf ${config.services.forgejo.dump.backupDir}/*
        '';
    };

    systemd.timers.${cleanupService} = {
      enable = true;
      description = "Daily clean up of forgejo dumps";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        Unit = "${cleanupService}.service";
      };
    };
  };
}
