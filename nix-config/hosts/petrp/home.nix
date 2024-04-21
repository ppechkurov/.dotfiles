{ pkgs, username, ... }:

{
  imports = [
    ../../modules/home-manager/programs
    ../../modules/home-manager/keyboard
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  services.mpd = {
    enable = true;
    musicDirectory = "/home/${username}/music";
  };

  programs.ncmpcpp.enable = true;
  programs.htop.enable = true;
  programs.chromium.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.simp1e-cursors;
    name = "Simp1e-Gruvbox-Dark";
  };

  home.packages = with pkgs; [
    cliphist
    gcc
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
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "23.11"; 
}
