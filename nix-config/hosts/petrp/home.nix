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
      source = ./us-prog;
      target = "xkb/symbols/us";
    };
  };

  home.username = "petrp";
  home.homeDirectory = "/home/petrp";

  home.stateVersion = "23.11"; 


  home.packages = with pkgs; [
    
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
