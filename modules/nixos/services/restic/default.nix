{ pkgs, lib, config, ... }:
let cfg = config.services.restic;
in {
  config = lib.mkIf cfg.enable {
    users.users.restic = { isNormalUser = true; };

    security.wrappers.restic = {
      source = "${pkgs.restic.out}/bin/restic";
      owner = "restic";
      group = "users";
      permissions = "u=rwx,g=,o=";
      capabilities = "cap_dac_read_search=+ep";
    };

    services.restic.backups.apps = {
      initialize = true;
      user = "restic";
      pruneOpts = [ "--keep-daily 7" ];
      paths = [ "/var/lib" ];
      timerConfig = {
        OnCalendar = "hourly"; # Empty string to disable the timer
        Persistent = true;
      };
    };
  };
}
