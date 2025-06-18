{ lib, osConfig, pkgs, inputs, ... }: {
  imports = [
    ../../modules/home-manager/programs/nvim
    ../../modules/home-manager/programs/zsh
    ../../modules/home-manager/keyboard
  ];

  home = { packages = [ ]; };

  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.htop.enable = true;
  programs.gpg.enable = true;

  services.gpg-agent.enable = true;
  services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}

