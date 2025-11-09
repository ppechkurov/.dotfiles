{ config, pkgs, pkgs-unstable, lib, globals, ... }:
let
  secrets = config.age.secrets;
  mattermostDnsName = "chat.slonverse.xyz";
  jellyfinDnsName = "media.slonverse.xyz";
  forgejoDnsName = "git.slonverse.xyz";
  forgejoSshPort = 2222;
  miniPcIp = globals.wg.peers.mini.networks.tun.ipv4;
in {
  imports = [
    ./hardware-configuration.nix
    ../../../modules/nixos/services/restic
    ./networking.secret.nix # generated at runtime by nixos-infect
  ];

  local.wireguard.server.enable = true;
  services.atuin.enable = true;

  services.transmission.enable = true;
  services.transmission = {
    package = pkgs.transmission_4;
    openFirewall = true;
    settings.incomplete-dir = "/mnt/sshfs/.incomplete";
    settings.download-dir = "/mnt/sshfs/Downloads";
    # extraFlags = [ "--log-level=debug" ];
  };

  # temp fix, because it wasn't starting with the default, which is "notify"
  systemd.services.transmission.serviceConfig.Type = lib.mkForce "simple";

  programs.nh.enable = true;
  environment.systemPackages =
    [ pkgs-unstable.mmctl pkgs-unstable.atuin pkgs.ncdu ];

  networking.firewall.allowedTCPPorts = [ 80 443 forgejoSshPort ];

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

    # forgejo ssh
    streamConfig = ''
      server {
        listen ${toString forgejoSshPort};
        proxy_pass ${miniPcIp}:22;
      }
    '';

    upstreams = {
      ${upstream} = {
        servers."127.0.0.1:${port}" = { };
        extraConfig = "keepalive 32;";
      };
      forgejo = {
        servers."${miniPcIp}:3000" = { };
        extraConfig = "keepalive 32;";
      };
    };

    # Details: [link](https://nixos.org/manual/nixos/stable/index.html#module-security-acme)
    virtualHosts = {
      git = {
        enableACME = true;
        forceSSL = true;

        serverName = forgejoDnsName;

        locations."/" = {
          proxyPass = "http://forgejo";
          extraConfig = ''
            proxy_set_header Connection $http_connection;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

            client_max_body_size 512M;
          '';
        };
      };

      mattermost = {
        enableACME = true;
        forceSSL = true;

        serverName = mattermostDnsName;

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

      "jellyfin" = {
        enableACME = true;
        forceSSL = true;

        serverName = jellyfinDnsName;

        locations."/" = {
          proxyPass = "http://${miniPcIp}:8096";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-Host $http_host;

            # Disable buffering when the nginx proxy gets very resource heavy upon streaming
            proxy_buffering off;
          '';
        };

        # Proxy Jellyfin Websockets traffic
        locations."/socket" = {
          proxyPass = "http://${miniPcIp}:8096";
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
          '';
        };
      };
    };
  };

  age.secrets.mattermost-environment.file = ./mattermost-environment.age;

  services.postgresqlBackup.enable = true;
  services.postgresqlBackup = {
    startAt = "*-*-* 01:00:00";
    pgdumpOptions = "--no-owner";
  };

  services.restic.backups.daily = {
    initialize = true;
    passwordFile = secrets.restic-password-file.path;
    repository = "sftp:restic@mini.local.wg:/mnt/hdd/restic";
    user = "restic";

    package = pkgs.writeShellScriptBin "restic" ''
      exec /run/wrappers/bin/restic "$@"
    '';

    paths = let
      mattermostDataDir = lib.mkIf config.services.mattermost.enable
        config.services.mattermost.dataDir;
      mattermostDb = lib.mkIf config.services.postgresqlBackup.enable
        "${config.services.postgresqlBackup.location}/all.sql.gz";
    in [ mattermostDataDir mattermostDb ];

    pruneOpts = [ "--keep-daily 7" ];
    timerConfig = {
      OnCalendar = "1:15";
      Persistent = true;
    };
  };

  services.mattermost = {
    enable = true;
    package = pkgs-unstable.mattermostLatest;
    siteUrl = "https://${mattermostDnsName}";
    database.peerAuth = true;

    # Local mode
    socket.enable = true;
    socket.export = true;

    plugins = with pkgs; [
      (fetchurl {
        url =
          "https://github.com/mattermost/mattermost-plugin-calls/releases/download/v1.7.1/mattermost-plugin-calls-v1.7.1-linux-amd64.tar.gz";
        hash = "sha256-wA6tmumDcjA9EqvYTYrHr1WaDM7iKNm0PDRe5TXZ/GA=";
      })
      (fetchurl {
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

      ServiceSettings = { EnableAPIPostDeletion = true; };

      EmailSettings = {
        SMTPServer = "mail.slonverse.xyz";
        SMTPPort = "465";
        SMTPServerTimeout = 5;
        FeedbackName = "Mattermost";
        FeedbackOrganization = "Mattermost";
        FeedbackEmail = "mattermost@slonverse.xyz";
        ReplyToAddress = "mattermost@slonverse.xyz";
        EnableSMTPAuth = true;
        ConnectionSecurity = "TLS";
      };

      SupportSettings = { SupportEmail = "support@slonverse.xyz"; };

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
