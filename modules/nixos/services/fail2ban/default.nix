{ config, lib, ... }:
let cfg = config.local.services.fail2ban;
in {
  options.local.services.fail2ban = with lib; {
    enable = mkEnableOption "fail2ban";
  };

  config = lib.mkIf cfg.enable {
    services.fail2ban = {
      enable = true;
      bantime-increment = {
        enable = true;
        factor = "4";
        maxtime = "48h";
      };
    };
  };
}

