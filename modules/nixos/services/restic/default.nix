{ pkgs, lib, config, ... }:
let
  cfg = { enable = true; };
  secrets = config.age.secrets;
in {
  config = lib.mkIf cfg.enable {
    age.secrets.restic-password-file = {
      file = ./restic-password-file.age;
      owner = "restic";
    };

    # see [link](https://wiki.nixos.org/wiki/Restic)
    users.users.restic = { isNormalUser = true; };

    security.wrappers.restic = {
      source = "${pkgs.restic.out}/bin/restic";
      owner = "restic";
      group = "restic";
      permissions = "u=rwx,g=,o=";
      capabilities = "cap_dac_read_search=+ep";
    };

    services.restic.backups.apps = {
      initialize = true;
      package = pkgs.writeShellScriptBin "restic" ''
        exec /run/wrappers/bin/restic "$@"
      '';
      repository = "/home/restic/test";
      user = "restic";
      passwordFile = secrets.restic-password-file.path;
      pruneOpts = [ "--keep-daily 7" ];
      paths = [ "/home/petrp/projects" ];
      timerConfig = {
        OnCalendar = "minutely";
        Persistent = true;
      };
    };
  };
}
