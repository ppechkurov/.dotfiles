{ self, ... }: {
  flake.modules.nixos.mini = { config, pkgs, lib, ... }: {
    imports = with self.modules.nixos; [ restic ];

    services.restic.backups.daily = {
      initialize = true;
      passwordFile = config.age.secrets.restic-password-file.path;
      repository = "/mnt/hdd/restic";
      user = "restic";

      package = pkgs.writeShellScriptBin "restic" ''
        exec /run/wrappers/bin/restic "$@"
      '';

      paths = let
        jellyfin = lib.mkIf config.services.jellyfin.enable
          config.services.jellyfin.dataDir;
        forgejo = lib.mkIf config.services.forgejo.enable
          config.services.forgejo.dump.backupDir;
      in [ jellyfin forgejo ];
      pruneOpts = [ "--keep-daily 7" ];
      timerConfig = {
        OnCalendar = "5:00";
        Persistent = true;
      };
    };

    systemd.services.copy-daily-backup =
      let repo = config.services.restic.backups.daily.repository;
      in {
        enable = true;
        description = "Make second copy of a daily backup";
        serviceConfig = {
          Type = "oneshot";
          User = "restic";
        };
        path = [ pkgs.rsync ];
        script = # bash
          ''
            rsync -az --delete ${repo} /mnt/backup/
          '';

        unitConfig = {
          OnSuccess = "notify-backup-success.service";
          OnFailure = "notify-backup-failure.service";
        };
      };

    systemd.timers.copy-daily-backup = {
      enable = true;
      description = "Make second copy of a daily backup";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "5:30";
        Persistent = true;
        Unit = "copy-daily-backup.service";
      };
    };
  };
}
