{ self, ... }:
let user = "petrp";
in {
  flake.modules.nixos.home-configuration = { pkgs, pkgs-unstable, ... }: {
    services.greetd.settings.default_session.user = user;

    home-manager.users.${user} = {
      imports = [ self.modules.homeManager.${user} ];
      _module.args.pkgs-unstable = pkgs-unstable;
    };
  };

  flake.modules.homeManager.${user} = {
    imports = with self.modules.homeManager; [
      foot
      keyboard
      hyprland
      hyprpaper
      nvim
      zsh

      { home.stateVersion = "23.11"; }
    ];
  };
}
