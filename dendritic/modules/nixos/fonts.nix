{
  flake.nixosModules.fonts = { pkgs, ... }: {
    fonts.fontconfig.enable = true;
    fonts.fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
    };

    fonts = {
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        font-awesome
        powerline-fonts
        powerline-symbols
        tuigreet
      ];
    };
  };
}
