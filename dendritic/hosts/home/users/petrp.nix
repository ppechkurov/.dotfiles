{ self, ... }:
let user = "petrp";
in {
  flake.modules.nixos.home = { pkgs, pkgs-unstable, ... }: {
    services.greetd.settings.default_session.user = user;

    home-manager.users.${user} = {
      imports = with self.modules.homeManager; [
        aws
        cli
        dconf
        firefox
        gpg
        gtk
        home # home it's a hostname in this case
        hyprland
        keyboard
        noctalia
        nvim
        qt
        screenshots
        xdg
      ];

      # provides pkgs-unstable param in hm modules
      _module.args = { inherit pkgs-unstable; };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      programs.zathura.enable = true;

      home.packages = with pkgs; [ telegram-desktop ];
      home.stateVersion = "24.05";
    };
  };
}
