{ lib, config, pkgs, ... }:
let cfg = config.local.forgejo;
in {
  options.local.forgejo = with lib; {
    enable = mkEnableOption "forgejo service";

    dnsName = mkOption {
      type = types.str;
      description = "Forgejo instance dns name";
    };
  };

  config = lib.mkIf cfg.enable {
    services.forgejo.enable = true;

    environment.systemPackages = [ pkgs.forgejo ];
    environment.variables = {
      FORGEJO_WORK_DIR = "${config.services.forgejo.stateDir}";
    };

    services.forgejo = {
      package = pkgs.forgejo;
      dump.enable = true;
      settings = {
        service.DISABLE_REGISTRATION = true;
        openid.ENABLE_OPENID_SIGNIN = false;
        server = { ROOT_URL = "https://${cfg.dnsName}"; };
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "git@pechkurov.org";
    };

    services.nginx = {
      enable = true;
      virtualHosts = let
        serverName = cfg.dnsName;
        port = toString config.services.forgejo.settings.server.HTTP_PORT;
      in {
        "${serverName}" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = { proxyPass = "http://localhost:${port}"; };
          inherit serverName;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}

