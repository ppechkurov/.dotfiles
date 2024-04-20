{ pkgs, username, ... }:

{
  
  imports = [
    # ../../modules/home-manager/development
    ../../modules/home-manager/programs
  ];

  xdg = {
    enable = true;
    configFile.xkb = {
      enable = true;
      source = ../../../xkb;
      recursive = true;
    };
    configFile.waybar = {
      enable = true;
      source = ../../../waybar;
      recursive = true;
    };
  };

  services.mpd = {
    enable = true;
    musicDirectory = "/home/${username}/music";
  };

  programs.ncmpcpp.enable = true;

  programs.git = {
    enable = true;
    userEmail = "petr.pechkurov@gmail.com";
    userName = "Petr Pechkurov";
  };

  programs.htop.enable = true;

  programs.waybar = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";
    antidote = {
      enable = true;
      plugins = [ "romkatv/powerlevel10k" ];
    };
    oh-my-zsh = {
      enable = true;
    };
    initExtra = ''
    source ~/.p10k.zsh
    '';
  };

  programs.chromium = {
    enable = true;
  };

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "23.11"; 

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.simp1e-cursors;
    name = "Simp1e-Gruvbox-Dark";
  };

  home.packages = with pkgs; [
    cliphist
    gcc
    gh
    lazygit
    mako
    ripgrep
  ];

  nixpkgs.config.allowUnfree = true;
  home.file = {
    nvim = {
      enable = true;
      source = ../../../nvim/.config/nvim;
      target = ".config/nvim";
      recursive = true;
    };
    ".p10k.zsh" = {
      enable = true;
      source = ../../../p10k/.p10k.zsh;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
