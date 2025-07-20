{ pkgs, config, ... }:
let
  owner = "restic";
  group = config.users.users.${owner}.group;
in {
  age.secrets = {
    restic-password-file = {
      file = ./restic-password-file.age;
      inherit owner group;
    };
    mattermost-bot-webhook-url-file = {
      file = ./mattermost-webhook-url-file.age;
      inherit owner group;
    };
  };

  # see [link](https://wiki.nixos.org/wiki/Restic)
  users.users.restic = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMrby7Og0kSdysnQKj54rCzJirVZqLFD8MYMV6pZRA2K restic@webdock"
    ];
  };

  environment.systemPackages = [ pkgs.restic ];
  security.wrappers.restic = {
    inherit owner group;
    source = "${pkgs.restic.out}/bin/restic";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };

  systemd.services.restic-backups-daily.unitConfig = {
    OnSuccess = "notify-backup-success.service";
    OnFailure = "notify-backup-failed.service";
  };

  systemd.services.notify-backup-success = {
    enable = true;
    description = "Notify on successful backup";
    serviceConfig = {
      Type = "oneshot";
      User = "restic";
    };

    script = # bash
      ''
        URL="$(cat ${config.age.secrets.mattermost-bot-webhook-url-file.path})"

        ${pkgs.curl}/bin/curl -X POST \
          -H 'Content-Type: application/json' \
          -d '{
                "attachments": [
                  {
                    "text": "**Backup Successful**\n\nHost: `${config.networking.hostName}`.\n\nDaily backup job completed successfuly!",
                    "color": "#36A64F"
                  }
                ]
              }' \
          "$URL"
      '';
  };

  systemd.services.notify-backup-failed =
    let logsCmd = "journalctl -u restic-backups-daily -n 20 -o cat";
    in {
      enable = true;
      description = "Notify on failed backup";
      serviceConfig = {
        Type = "oneshot";
        User = "restic";
      };

      script = # bash
        ''
          URL="$(cat ${config.age.secrets.mattermost-bot-webhook-url-file.path})"

          ${pkgs.curl}/bin/curl -X POST \
            -H 'Content-Type: application/json' \
            -d '{
                  "attachments": [
                    {
                      "text": "**Backup Alert**\n\nDaily backup job failed. Host: `${config.networking.hostName}`.\n\nTo check the logs:\n```\n${logsCmd}\n```",
                      "color": "#DD0000"
                    }
                  ]
                }' \
            "$URL"
        '';
    };

}
