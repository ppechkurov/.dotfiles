{ lib, osConfig, pkgs, inputs, ... }:
with osConfig; {
  imports = [ ./programs ./services ./keyboard ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
  };

  home.activation.screenshots = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p /home/${username}/Pictures/screenshots
    mkdir -p /home/${username}/projects
  '';

  home = {
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.simp1e-cursors;
      name = "Simp1e-Gruvbox-Dark";
      size = 24;
    };
    packages = with pkgs;
      let jira = inputs.jira.packages.${pkgs.system}.default;
      in [ jira cliphist dconf gcc pavucontrol ripgrep telegram-desktop ];
  };

  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.mako.enable = true;
  services.network-manager-applet.enable = false;

  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;

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
  qt.platformTheme.name = "adwaita";
  qt.style.name = "adwaita-dark";

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}

