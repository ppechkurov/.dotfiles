{
  flake.modules.nixos.opencode = { lib, pkgs, pkgs-unstable, ... }: {
    containers.opencode = {
      ephemeral = false;
      autoStart = true;

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
      };

      config = { config, ... }: {
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

        environment.systemPackages = with pkgs-unstable; [
          direnv
          tmux
          docker
          gh
          git
          nodejs_24
          opencode
          pi-coding-agent
          vim
        ];

        system.stateVersion = "25.11";
      };
    };
  };
}
