{ self, ... }: {
  flake.modules.nixos.webdock = { config, pkgs, lib, ... }: {
    imports = with self.modules.nixos; [ restic ];

    services.postgresqlBackup.enable = true;
    services.postgresqlBackup = {
      startAt = "*-*-* 01:00:00";
      pgdumpOptions = "--no-owner";
    };

    services.restic.backups.daily = {
      initialize = true;
      passwordFile = config.age.secrets.restic-password-file.path;
      repository = "sftp:restic@mini.wg:/mnt/hdd/restic";
      user = "restic";

      package = pkgs.writeShellScriptBin "restic" ''
        exec /run/wrappers/bin/restic "$@"
      '';

      paths = let
        mattermostDataDir = lib.mkIf config.services.mattermost.enable
          config.services.mattermost.dataDir;
        mattermostDb = lib.mkIf config.services.postgresqlBackup.enable
          "${config.services.postgresqlBackup.location}/all.sql.gz";
      in [ mattermostDataDir mattermostDb ];

      pruneOpts = [ "--keep-daily 7" ];
      timerConfig = {
        OnCalendar = "1:15";
        Persistent = true;
      };
    };
  };
}
