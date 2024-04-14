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

  programs.git = {
    enable = true;
    userEmail = "petr.pechkurov@gmail.com";
    userName = "Petr Pechkurov";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };

  home.username = "petrp";
  home.homeDirectory = "/home/petrp";

  home.stateVersion = "23.11"; 


  home.packages = with pkgs; [
    alacritty
    foot
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
