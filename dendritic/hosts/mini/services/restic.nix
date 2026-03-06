{ self, ... }: {
  flake.modules.nixos.mini = { config, lib, pkgs, ... }:
    let
      owner = "restic";
      group = config.users.users.${owner}.group;
      mkBackupNotifyService = status: message: {
        enable = true;
        description = "Notify on restic backup ${status}";
        serviceConfig = {
          Type = "oneshot";
          User = owner;
        };
        script = "${lib.getExe pkgs.mattermost-send} '${message}' ${status} ";
      };
    in {
      imports = with self.modules.nixos; [ mattermost-send ];

      age.secrets.restic-password-file = {
        file = ./restic-password-file.age;
        inherit owner group;
      };

      # see [link](https://wiki.nixos.org/wiki/Restic)
      users.users.restic = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMrby7Og0kSdysnQKj54rCzJirVZqLFD8MYMV6pZRA2K restic@webdock"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/8sFXfWRrIE+n4TtvawXjd1QKIYadM2OR9PGOxHKrP petrp@home"
        ];
      };

      environment.systemPackages = [ pkgs.restic ];
      security.wrappers.restic = {
        inherit owner group;
        source = "${pkgs.restic.out}/bin/restic";
        permissions = "u=rwx,g=,o=";
        capabilities = "cap_dac_read_search=+ep";
      };

      systemd.services.notify-backup-success = let
        message = ''
          **Backup Job Successful**

          Host: `${config.networking.hostName}`.

          Backup job completed successfuly!
        '';
      in mkBackupNotifyService "success" message;

      systemd.services.notify-backup-failure = let
        message = ''
          **Backup Job Failed**

          Host: `${config.networking.hostName}`.

          Backup job completed has been failed!
        '';
      in mkBackupNotifyService "failure" message;

      systemd.services.restic-backups-daily.unitConfig = {
        OnSuccess = "notify-backup-success.service";
        OnFailure = "notify-backup-failure.service";
      };
    };
}
