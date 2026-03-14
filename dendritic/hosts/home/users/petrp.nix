{ self, ... }:
let user = "petrp";
in {
  flake.modules.nixos.home = { pkgs, pkgs-unstable, ... }: {
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
        home # home it's a hostname in this case
        hyprland
        keyboard
        noctalia
        nvim
        qt
        screenshots
        tofi
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

      # [see](https://codeberg.org/PassFF/passff-host#preferences)
      programs.firefox = {
        package = pkgs.firefox.override {
          nativeMessagingHosts = [
            (pkgs.passff-host.overrideAttrs (old: {
              dontStrip = true;
              patchPhase = ''
                sed -i 's#COMMAND = "pass"#COMMAND = "${
                  pkgs.pass-wayland.withExtensions (ext: with ext; [ pass-otp ])
                }/bin/pass"#' src/passff.py
              '';
            }))
          ];
        };
      };

      home.packages = with pkgs; [ telegram-desktop ];
      home.stateVersion = "24.05";
    };
  };
}
