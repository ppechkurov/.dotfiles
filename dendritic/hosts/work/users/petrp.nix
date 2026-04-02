{ self, ... }:
let user = "petrp";
in {
  flake.modules.nixos.work = { pkgs, pkgs-unstable, ... }: {
    services.greetd.settings.default_session.user = user;

    home-manager.users.${user} = {
      imports = with self.modules.homeManager; [
        aerc
        aws
        dconf
        firefox
        gh
        gpg
        gtk
        hyprland
        keyboard
        mycli
        noctalia
        nvim
        passff
        qt
        screenshots
        sesh
        tofi
        work
        xdg
      ];

      programs.git.settings = {
        user.signingkey = "F7C0B35DA9397DD1";
        commit.gpgsign = true;
      };

      # access pkgs-unstable param in hm modules
      _module.args = { inherit pkgs-unstable; };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      programs.zathura.enable = true;

      home.packages = with pkgs; [ signal-desktop slack telegram-desktop ];
      home.stateVersion = "24.05";
    };
  };
}
