{ config, pkgs, ... }:

{
  
  imports = [
    # ../../modules/home-manager/development
    ../../modules/home-manager/programs
  ];

  xdg = {
    enable = true;
    configFile.xkb = {
      enable = true;
      source = ../../../xkb/symbols/us;
      target = "xkb/symbols/us";
    };
  };

  home.username = "petrp";
  home.homeDirectory = "/home/petrp";

  home.stateVersion = "23.11"; 


  home.packages = with pkgs; [
    alacritty
    git
  ];

  nixpkgs.config.allowUnfree = true;
  home.file = {

  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
