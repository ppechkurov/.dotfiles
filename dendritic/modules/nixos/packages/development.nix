{ inputs, self, ... }: {
  flake.modules.nixos.development = { lib, pkgs, pkgs-unstable, ... }:
    let
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
      containers.development = {
        ephemeral = false;
        autoStart = true;
        nixpkgs = "${inputs.nixpkgs-unstable}";

        bindMounts = {
          "/run/docker.sock" = {
            hostPath = "/run/user/1000/docker.sock";
            isReadOnly = false;
          };
          "/home/petrp/projects" = {
            hostPath = "/home/petrp/projects";
            isReadOnly = false;
          };
          "/home/petrp/.dotfiles" = {
            hostPath = "/home/petrp/.dotfiles";
            isReadOnly = true;
          };
          "/home/petrp/.claude" = {
            hostPath = "/home/petrp/.claude";
            isReadOnly = false;
          };
          "/home/petrp/.codex" = {
            hostPath = "/home/petrp/.codex";
            isReadOnly = false;
          };
        };

        config = { config, pkgs, ... }: {
          imports = [ hmModule ];

          nixpkgs.config.allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [ "claude-code" "codex" ];

          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            backupFileExtension = "backup";
            users.petrp = {
              imports = hmUserModules;
              _module.args = { inherit pkgs-unstable; };
              home.stateVersion = "24.05";
            };
          };

          users.users.petrp = {
            isNormalUser = true;
            shell = pkgs.zsh;
            home = "/home/petrp";
            description = "Petr Pechkurov";
            group = "users";
          };

          services.gnome.gnome-keyring.enable = true;
          security.pam.services.login.enableGnomeKeyring = true;

          environment.sessionVariables = {
            DOCKER_HOST = "unix:///run/docker.sock";
            DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
          };

          systemd.tmpfiles.rules = [
            "d /run/user/1000 0755 petrp users -"
            "f+ /home/petrp/.docker/config.json 0644 petrp users - {}"
          ];

          programs.zsh.enable = true;

          environment.systemPackages = with pkgs; [
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
