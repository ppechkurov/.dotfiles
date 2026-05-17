{ self, ... }:
let user = "petrp";
in {
  flake.modules.nixos.home = { pkgs, pkgs-unstable, ... }: {
    home-manager.users.${user} = {
      imports = with self.modules.homeManager; [
        aerc
        aws
        dconf
        firefox
        gh
        gpg
        gtk
        home # home it's a hostname in this case
        hyprland
        keyboard
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
        xdg
      ];

      programs.smug.enable = true;

      # provides pkgs-unstable param in hm modules
      _module.args = { inherit pkgs-unstable; };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      programs.zathura.enable = true;

      wayland.windowManager.hyprland.settings.input = {
        kb_layout = "us,ru,us";
        kb_variant = "dvorak,,basic";
      };

      home.packages = with pkgs; [ telegram-desktop ];
      home.stateVersion = "24.05";

      programs.git.settings = {
        user.signingkey = "petr pechkurov (home) <petr.pechkurov@gmail.com>";
      };
    };
  };
}
