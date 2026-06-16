{ inputs, self, ... }: {
  flake.modules.nixos.development = { lib, pkgs, pkgs-unstable, ... }:
    let
      user = "petrp";
      libnotify = "${pkgs.libnotify}/bin/notify-send";
      sound =
        "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/complete.oga";

      codex-notify-watch = pkgs.writeShellApplication {
        name = "codex-notify-watch";
        runtimeInputs = [ pkgs.libnotify pkgs.jq ];
        text = builtins.replaceStrings [ "@libnotify@" "@sound@" ] [
          libnotify
          sound
        ] (builtins.readFile ./scripts/codex-notify-watch.sh);
      };

      codex-notify-send = pkgs.writeShellApplication {
        name = "codex-notify-send";
        text = builtins.readFile ./scripts/codex-notify-send.sh;
      };

      hmModule = inputs.home-manager.nixosModules.home-manager;
      hmUserModules = with self.modules.homeManager; [
        atuin
        aws
        fzf
        gh
        git
        gpg
        nodejs
        yazi
        zoxide
        zsh
      ];
    in {
      systemd.tmpfiles.rules =
        [ "f+ /tmp/codex-notify 0644 ${user} users - -" ];

      home-manager.users.${user}.systemd.user.services.codex-notify-watch = {
        Unit.Description = "Codex notification watcher";
        Service.ExecStart = "${codex-notify-watch}/bin/codex-notify-watch";
        Service.Restart = "on-failure";
        Service.Environment = "CODEX_NOTIFY_FILE=/tmp/codex-notify";
        Install.WantedBy = [ "default.target" ];
      };

      containers.development = {
        ephemeral = false;
        autoStart = true;
        nixpkgs = "${inputs.nixpkgs-unstable}";

        bindMounts = {
          "/run/docker.sock" = {
            hostPath = "/run/user/1000/docker.sock";
            isReadOnly = false;
          };
          "/home/${user}/projects" = {
            hostPath = "/home/${user}/projects";
            isReadOnly = false;
          };
          "/home/${user}/.dotfiles" = {
            hostPath = "/home/${user}/.dotfiles";
            isReadOnly = true;
          };
          "/home/${user}/.claude" = {
            hostPath = "/home/${user}/.claude";
            isReadOnly = false;
          };
          "/home/${user}/.codex" = {
            hostPath = "/home/${user}/.codex";
            isReadOnly = false;
          };
          "/home/${user}/.npmrc" = {
            hostPath = "/home/${user}/.npmrc";
            isReadOnly = true;
          };
          "/tmp/codex-notify" = {
            hostPath = "/tmp/codex-notify";
            isReadOnly = false;
          };
        };

        config = { config, pkgs, ... }: {
          imports = [ hmModule ];

          nixpkgs.config.allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [ "claude-code" ];

          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            backupFileExtension = "backup";
            users.${user} = {
              imports = hmUserModules;
              _module.args = { inherit pkgs-unstable; };
              home.enableNixpkgsReleaseCheck = false;
              home.stateVersion = "25.11";
            };
          };

          users.users.${user} = {
            isNormalUser = true;
            shell = pkgs.zsh;
            home = "/home/${user}";
            description = "Petr Pechkurov";
            group = "users";
          };

          services.gnome.gnome-keyring.enable = true;
          security.pam.services.login.enableGnomeKeyring = true;

          environment.sessionVariables = {
            DOCKER_HOST = "unix:///run/docker.sock";
            DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
            CODEX_NOTIFY_FILE = "/tmp/codex-notify";
          };

          systemd.tmpfiles.rules = [
            "d /run/user/1000 0755 ${user} users -"
            "f+ /home/${user}/.docker/config.json 0644 ${user} users - {}"
          ];

          programs.zsh.enable = true;

          environment.systemPackages = with pkgs; [
            codex-notify-send
            direnv
            jq
            docker
            gh
            git
            nodejs_24
            claude-code
            codex
            vim
          ];

          system.stateVersion = "25.11";
        };
      };
    };
}
