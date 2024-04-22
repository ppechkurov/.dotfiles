{ pkgs, user, ... }:

{
  imports =
    [ ../../modules/home-manager/programs ../../modules/home-manager/keyboard ];

  home.username = user;
  home.homeDirectory = "/home/${user}";

  services.mpd = {
    enable = true;
    musicDirectory = "/home/${user}/music";
  };

  programs.cava.enable = true;
  services.mpdris2.enable = true;

  programs.ncmpcpp.enable = true;
  programs.htop.enable = true;
  programs.chromium.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.simp1e-cursors;
    name = "Simp1e-Gruvbox-Dark";
  };

  home.packages = with pkgs; [ cliphist gcc mako pavucontrol ripgrep ];

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
