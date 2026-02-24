{ self, ... }:
let user = "petrp";
in {
  flake.modules.nixos.home-configuration = { pkgs, pkgs-unstable, ... }: {
    services.greetd.settings.default_session.user = user;

    home-manager.users.${user} = {
      imports = [
        self.modules.homeManager.${user}
        self.modules.homeManager.home-overrides
      ];
      # access pkgs-unstable param in hm modules
      _module.args = { inherit pkgs-unstable; };
    };
  };

  flake.modules.homeManager.${user} = { pkgs, config, ... }: {
    imports = with self.modules.homeManager;
      [ aerc atuin firefox foot fzf gh git hypridle hyprland hyprpaper ]
      ++ [ mako mycli nvim tmux tofi waybar yazi zoxide zsh screenshots ]
      ++ [ dconf gpg gtk keyboard qt xdg noctalia ];

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
    programs.htop.enable = true;
    # programs.zathura.enable = true;

    programs.waybar.settings.mainBar."hyprland/workspaces" = {
      persistent-workspaces = {
        DP-4 = [ 1 2 3 4 5 ];
        DVI-D-1 = [ 6 7 8 9 10 ];
      };
    };

    home.packages = with pkgs; [ telegram-desktop pavucontrol ];
    home.stateVersion = "24.05";
  };
}
