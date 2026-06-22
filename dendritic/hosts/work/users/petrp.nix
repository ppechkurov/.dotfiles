{ self, ... }:
let user = "petrp";
in {
  flake.modules.nixos.work = { lib, pkgs, pkgs-unstable, ... }: {
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
        niri
        noctalia
        nodejs
        nvim
        passff
        qt
        screenshots
        sesh
        tofi
        vicinae
        work
        xdg
      ];

      programs.git.settings = {
        user.email = self.globals.emails.work;
        user.signingkey = "2B456328DD5DC07D";
        commit.gpgsign = true;
      };

      # access pkgs-unstable param in hm modules
      _module.args = { inherit pkgs-unstable; };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      programs.zathura.enable = true;

      home.packages = with pkgs; [
        signal-desktop
        slack
        pkgs-unstable.telegram-desktop
      ];
      home.stateVersion = "24.05";
    };
  };
}
