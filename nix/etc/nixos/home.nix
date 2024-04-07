{ config, pkgs, ... }:

{
  home.username = "nixtest";
  home.homeDirectory = "/home/nixtest";

  programs = {
    git = {
      enable = true;
      userName = "Petr Pechkurov";
      userEmail = "petr.pechkurov@gmail.com";
    };

    lazygit = {
      enable = true;
    };

    alacritty = {
      enable = true;
      settings = {
        window = {
          decorations = "None";
          opacity = 0.9;
          startup_mode = "Maximized";
        };
        font = {
          size = 14;
        };
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [];
        theme = "robbyrussell";
      };
    };
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
