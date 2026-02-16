{ self, ... }:
let user = "petrp";
in {
  flake.modules.nixos.home-configuration = { pkgs, pkgs-unstable, ... }: {
    services.greetd.settings.default_session.user = user;

    home-manager.users.${user} = {
      imports = [ self.modules.homeManager.${user} ];
      # access pkgs-unstable param in hm modules
      _module.args = { inherit pkgs-unstable; };
    };
  };

  flake.modules.homeManager.${user} = {
    imports = with self.modules.homeManager; [
      aerc
      atuin
      firefox
      foot
      fzf
      gh
      git
      hyprland
      hyprpaper
      keyboard
      mako
      mycli
      nvim
      tmux
      tofi
      waybar
      yazi
      zsh

      { home.stateVersion = "23.11"; }
    ];

    programs.waybar.settings.mainBar."hyprland/workspaces" = {
      persistent-workspaces = {
        DP-1 = [ 1 2 3 4 5 ];
        DVI-D-1 = [ 6 7 8 9 10 ];
      };
    };
  };
}
