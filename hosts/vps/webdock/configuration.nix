{ pkgs, pkgs-unstable, config, ... }:
let
  serverName = "matter-pp.duckdns.org";
  cfg = config.services.mattermost;
in {
  imports = [
    ./hardware-configuration.nix
    ./networking.secret.nix # generated at runtime by nixos-infect
  ];

  local.wireguard.server.enable = true;

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "petr.pechkurov@gmail.com";
  };

  services.nginx = let
    upstream = "mattermost";
    port = "8065";
  in {
    enable = true;

    recommendedOptimisation = true;

    upstreams = {
      ${upstream} = {
        servers."127.0.0.1:${port}" = { };
        extraConfig = "keepalive 32;";
      };
    };

    virtualHosts = {
      "${serverName}" = {
        enableACME = true;
        forceSSL = true;

        inherit serverName;

        # [Docs](https://docs.mattermost.com/deploy/server/setup-nginx-proxy.html)
        # Actually, it should work without this. But it required if you need webhooks.
        locations."~ /api/v[0-9]+/(users/)?websocket$" = {
          proxyPass = "http://${upstream}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Connection "upgrade";
            client_max_body_size 50M;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Frame-Options SAMEORIGIN;
            proxy_buffers 256 16k;
            proxy_buffer_size 16k;
            client_body_timeout 60s;
            send_timeout 300s;
            lingering_timeout 5s;
            proxy_connect_timeout 90s;
            proxy_send_timeout 300s;
            proxy_read_timeout 90s;
          '';
        };

        locations."/" = {
          proxyPass = "http://${upstream}";
          extraConfig = ''
            client_max_body_size 50M;
            proxy_set_header Connection "";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Frame-Options SAMEORIGIN;
            proxy_buffers 256 16k;
            proxy_buffer_size 16k;
            proxy_read_timeout 600s;
          '';
        };
      };
    };
  };

  environment.systemPackages = [ pkgs-unstable.mmctl ];
  environment.variables = { MMCTL_LOCAL_SOCKET_PATH = cfg.socket.path; };

  age.secrets.mattermost-environment.file = ./mattermost-environment.age;

  services.mattermost = {
    enable = true;
    package = pkgs-unstable.mattermostLatest;
    siteUrl = "https://${serverName}";

    # Local mode
    socket = { enable = true; };

    plugins = [
      (pkgs.fetchurl {
        url =
          "https://github.com/mattermost/mattermost-plugin-calls/releases/download/v1.7.1/mattermost-plugin-calls-v1.7.1-linux-amd64.tar.gz";
        hash = "sha256-wA6tmumDcjA9EqvYTYrHr1WaDM7iKNm0PDRe5TXZ/GA=";
      })
      (pkgs.fetchurl {
        url =
          "https://github.com/mattermost/mattermost-plugin-github/releases/download/v2.4.0/mattermost-plugin-github-v2.4.0-linux-amd64.tar.gz";
        hash = "sha256-b/k5K5uAtRcBFVpCp1XYNXzGVXEp4l4tF2p7Gms6lW4=";
      })
    ];

    environmentFile = config.age.secrets.mattermost-environment.path;

    settings = {
      LogSettings = {
        ConsoleLevel = "INFO";
        ConsoleJson = false;
      };

      PluginSettings = {
        EnableMarketplace = false;
        EnableRemoteMarketplace = false;

        PluginStates = {
          "com.mattermost.calls" = { Enable = true; };
          github = { Enable = true; };
          mattermost-ai = { Enable = false; };
          playbooks = { Enable = false; };
        };

        # Plugins are configured in age secret mattermost-environment.age.
        # There are some secrets in it. Haven't found a way to declare secrets
        # and non secrets separately.
        Plugins = { };
      };
    };
  };
}
