{ lib, config, pkgs-unstable, ... }:
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

    environment.systemPackages = [ pkgs-unstable.forgejo ];

    services.forgejo = {
      package = pkgs-unstable.forgejo;
      dump.enable = true;
      # stateDir = "/home/forgejo/data"; # this doesn't work at the moment
      settings = {
        service.DISABLE_REGISTRATION = true;
        openid.ENABLE_OPENID_SIGNIN = false;
        server = { ROOT_URL = "https://${cfg.dnsName}"; };
        "git.timeout" = {
          MIGRATE = 4200;
          MIRROR = 4200;
          CLONE = 4200;
          PULL = 4200;
        };
      };
    };

    # networking.firewall.allowedTCPPorts = [ 3000 ];
  };
}

