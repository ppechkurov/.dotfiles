{
  flake.modules.nixos.fonts = { pkgs, ... }: {
    fonts.fontconfig.enable = true;
    fonts.fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
    };

    fonts = {
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.victor-mono
        nerd-fonts.shure-tech-mono
        dina-font
        fira-code
        fira-code-symbols
        font-awesome
        liberation_ttf
        mplus-outline-fonts.githubRelease
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        powerline-fonts
        powerline-symbols
        proggyfonts
        tuigreet
      ];
    };
  };
}
