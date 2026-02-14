{ self, ... }:
let user = "petrp";
in {
  flake.modules.nixos.home-configuration =
    { pkgs, pkgs-unstable, config, ... }: {
      services.greetd.settings.default_session.user = user;

      home-manager.users.${user} = {
        imports = [ self.modules.homeManager.${user} ];
        # allows pkgs-unstable param in hm modules
        _module.args = { inherit pkgs-unstable; };
      };
    };

  flake.modules.homeManager.${user} = {
    imports = with self.modules.homeManager; [
      aerc
      atuin
      firefox
      foot
      gh
      git
      hyprland
      hyprpaper
      keyboard
      nvim
      zsh

      { home.stateVersion = "23.11"; }
    ];
  };
}
