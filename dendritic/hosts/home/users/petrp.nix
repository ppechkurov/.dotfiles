{ self, ... }:
let user = "petrp";
in {
  flake.modules.nixos.home-configuration = { pkgs, pkgs-unstable, ... }: {
    services.greetd.settings.default_session.user = user;

    home-manager.users.${user} = {
      imports = with self.modules.homeManager; [
        self.modules.homeManager.${user}
        home-overrides
        cli
        nvim
        aws
      ];

      # access pkgs-unstable param in hm modules
      _module.args = { inherit pkgs-unstable; };
    };
  };

  flake.modules.homeManager.${user} = { pkgs, config, ... }: {
    imports = with self.modules.homeManager;
      [ firefox hyprland ] ++ [ mako waybar screenshots ]
      ++ [ dconf gpg gtk keyboard qt xdg noctalia ];

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
    # programs.zathura.enable = true;

    home.packages = with pkgs; [ telegram-desktop pavucontrol ];
    home.stateVersion = "24.05";
  };
}
