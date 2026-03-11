{ self, ... }: {
  flake.modules.nixos.webdock = { pkgs-unstable, pkgs, config, ... }: {
    age.secrets.mattermost-environment.file = ./mattermost-environment.age;

    services.mattermost.enable = true;

    services.mattermost = {
      package = pkgs-unstable.mattermostLatest;
      siteUrl = "https://${self.globals.dns.mattermost}";
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

      settings = let domain = self.globals.dns.domain;
      in {
        LogSettings = {
          ConsoleLevel = "INFO";
          ConsoleJson = false;
        };

        ServiceSettings = { EnableAPIPostDeletion = true; };

        EmailSettings = {
          SMTPServer = self.globals.dns.mail;
          SMTPPort = "465";
          SMTPServerTimeout = 5;
          FeedbackName = "Mattermost";
          FeedbackOrganization = "Mattermost";
          FeedbackEmail = "mattermost@${domain}";
          ReplyToAddress = "mattermost@${domain}";
          EnableSMTPAuth = true;
          ConnectionSecurity = "TLS";
        };

        SupportSettings = { SupportEmail = "support@${domain}"; };

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
  };
}
