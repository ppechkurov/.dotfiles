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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  home.username = "petrp";
  home.homeDirectory = "/home/petrp";

  home.stateVersion = "23.11"; 


  home.packages = with pkgs; [
    foot
  ];

  nixpkgs.config.allowUnfree = true;
  home.file = {
    nvim = {
      enable = true;
      source = ../../../nvim/.config/nvim;
      target = ".config/nvim";
      recursive = true;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
