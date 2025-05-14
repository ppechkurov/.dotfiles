{ lib, config, pkgs, ... }:
let cfg = config.local.forgejo;
in {
  options.local.forgejo = with lib; {
    enable = mkEnableOption "forgejo service";

    dnsName = mkOption {
      type = types.str;
      description = "Forgejo instance dns name";
      default = "test.shit.com";
    };
  };

  config = lib.mkIf cfg.enable {
    services.forgejo.enable = true;

    environment.systemPackages = [ pkgs.forgejo ];

    services.forgejo = {
      package = pkgs.forgejo;
      dump.enable = true;
      # stateDir = "/home/forgejo/data"; # this doesn't work at the moment
      settings = {
        service.DISABLE_REGISTRATION = true;
        openid.ENABLE_OPENID_SIGNIN = false;
        server = { ROOT_URL = "https://${cfg.dnsName}"; };
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}

