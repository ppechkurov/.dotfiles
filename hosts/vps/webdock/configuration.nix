{ pkgs, pkgs-unstable, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.secret.nix # generated at runtime by nixos-infect
  ];

  local.wireguard.server.enable = true;

  # services.ejabberd.enable = true;
  # services.ejabberd.configFile = "/etc/ejabberd.yml";

  security.acme = {
    acceptTerms = true;
    defaults.email = "petr.pechkurov@gmail.com";
  };

  services.nginx = {
    enable = true;

    virtualHosts = {
      "matter-pp.duckdns.org" = {
        enableACME = true;
        forceSSL = true;
        serverName = "matter-pp.duckdns.org";
        locations."^~ /" = let
          host = "127.0.0.1";
          port = "8065";
        in {
          proxyPass = "http://${host}:${port}";
          proxyWebsockets = true;
        };
      };
    };
  };

  environment.systemPackages = [ pkgs-unstable.mmctl ];

  services.mattermost = {
    enable = true;
    package = pkgs-unstable.mattermost;
    siteUrl = "https://matter-pp.duckdns.org";
    plugins = [
      (pkgs.fetchurl {
        url =
          "https://github.com/mattermost/mattermost-plugin-calls/releases/download/v1.7.1/mattermost-plugin-calls-v1.7.1-linux-amd64.tar.gz";
        hash = "sha256-wA6tmumDcjA9EqvYTYrHr1WaDM7iKNm0PDRe5TXZ/GA=";
      })
      (pkgs.fetchurl {
        url =
          "https://github.com/moussetc/mattermost-plugin-giphy/releases/download/v3.0.0/com.github.moussetc.mattermost.plugin.giphy-3.0.0.tar.gz";
        hash = "sha256-/i2Tfbb+2B5TBb0mXYZTBH3jF3TZAjmiiyTxL9gx/a0=";
      })
    ];
    extraConfig.ServiceSettings.EnableLocalMode = true;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
