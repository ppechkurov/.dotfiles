{
  flake.modules.nixos.opencode = { lib, pkgs, pkgs-unstable, ... }: {
    containers.opencode = {
      ephemeral = false;
      autoStart = true;

      bindMounts = {
        "/home/petrp/projects" = {
          hostPath = "/home/petrp/projects";
          isReadOnly = false;
        };
        "/home/petrp/.dotfiles" = {
          hostPath = "/home/petrp/.dotfiles";
          isReadOnly = true;
        };
      };

      config = { config, pkgs, ... }: {
        users.users.petrp = {
          isNormalUser = true;
          shell = pkgs.zsh;
          home = "/home/petrp";
          description = "Petr Pechkurov";
          group = "users";
        };
        programs.zsh.enable = true;

        services.gnome.gnome-keyring.enable = true;
        security.pam.services.login.enableGnomeKeyring = true;

        environment.systemPackages = with pkgs-unstable; [ direnv opencode ];
        system.stateVersion = "25.11";
      };
    };
  };
}

