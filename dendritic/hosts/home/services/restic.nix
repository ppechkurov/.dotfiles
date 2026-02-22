{ self, ... }: {
  flake.modules.nixos.home-services = { lib, pkgs, config, ... }:
    let
      mkSyncNotifyService = status: message: {
        enable = true;
        description = "Notify on restic sync ${status}";
        serviceConfig = {
          Type = "oneshot";
          User = "petrp";
        };
        script = "${lib.getExe pkgs.mattermost-send} '${message}' ${status}";
      };
      resticServiceName = "sync-restic-repo";
    in {
      imports = with self.modules.nixos; [ mattermost-send ];

      systemd.services.${resticServiceName} = {
        enable = true;
        description = "Sync restic backup repo";
        serviceConfig = {
          Type = "oneshot";
          User = "petrp";
        };
        path = [ pkgs.openssh pkgs.rclone ];

        script = # bash
          ''
            rclone sync mini:/mnt/hdd/restic $HOME/restic
          '';

        unitConfig = {
          OnSuccess = "notify-sync-success.service";
          OnFailure = "notify-sync-failure.service";
        };
      };

      systemd.timers.${resticServiceName} = {
        enable = true;
        description = "Daily sync of restic backup repo at midnight";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
          Unit = "${resticServiceName}.service";
        };
      };

      systemd.services.notify-sync-success = let
        message = ''
          **Sync Job Successful**

          Host: `${config.networking.hostName}`.

          Sync job completed successfuly!
        '';
      in mkSyncNotifyService "success" message;

      systemd.services.notify-sync-failure = let
        message = ''
          **Sync Job Failed**

          Host: `${config.networking.hostName}`.

          Sync job has been failed!
        '';
      in mkSyncNotifyService "failure" message;
    };
}
