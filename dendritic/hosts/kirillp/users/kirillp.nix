{ self, ... }:
let user = "kirillp";
in {
  flake.modules.nixos.kirillp = { pkgs, pkgs-unstable, ... }: {
    services.greetd.settings.default_session.user = user;

    programs.zsh.enable = true;
    users.users.${user} = {
      description = "Kirill Pechkurov";
      extraGroups = [ "power" ];
      isNormalUser = true;
      shell = pkgs.zsh;
    };

    home-manager.users.${user} = {
      imports = with self.modules.homeManager; [
        cli
        dconf
        firefox
        gtk
        hyprland
        keyboard
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

      # wayland.windowManager.hyprland.settings.input = {
      #   kb_layout = "ru,us";
      #   kb_variant = ",basic";
      # };

      home.stateVersion = "24.05";
    };
  };
}
