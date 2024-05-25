{ lib, osConfig, pkgs, ... }:
with osConfig; {
  imports = [ ./programs ./services ./keyboard ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
  };

  home.activation.screenshots = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p /home/${username}/Pictures/screenshots
  '';

  home = {
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.simp1e-cursors;
      name = "Simp1e-Gruvbox-Dark";
      size = 24;
    };
    packages = with pkgs; [
      cliphist
      dconf
      gcc
      pavucontrol
      ripgrep
      telegram-desktop
    ];
  };

  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.mako.enable = true;
  services.network-manager-applet.enable = true;

  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryFlavor = "gnome3";

  programs.swaylock.enable = true;
  programs.cava.enable = true;
  programs.htop.enable = true;
  programs.chromium.enable = true;
  programs.chromium.extensions = [
    { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock
    { id = "gfbliohnnapiefjpjlpjnehglfpaknnc"; } # surfingkeys
  ];
  programs.yt-dlp.enable = true;

  gtk.enable = true;
  gtk.theme = {
    name = "Adwaita-dark";
    package = pkgs.gnome.gnome-themes-extra;
  };

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
  };

  qt.enable = true;
  qt.platformTheme = "gnome";
  qt.style.name = "adwaita-dark";

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = [ "chromium-browser.desktop" ];
        "x-scheme-handler/https" = "chromium-browser.desktop";
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}

