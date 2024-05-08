{ osConfig, pkgs, ... }:
with osConfig; {
  imports = [ ./programs ./keyboard ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
  };

  home = {
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.simp1e-cursors;
      name = "Simp1e-Gruvbox-Dark";
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

  services = {
    mpd = {
      enable = true;
      musicDirectory = "/home/${username}/music";
    };
    mpdris2.enable = true;
    mako.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };

  programs.cava.enable = true;
  programs.htop.enable = true;
  programs.ncmpcpp.enable = true;
  programs.chromium.enable = true;
  programs.chromium.extensions = [
    { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock
    { id = "gfbliohnnapiefjpjlpjnehglfpaknnc"; } # surfingkeys
  ];

  gtk.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
    };
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

