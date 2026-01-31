{ lib, osConfig, pkgs, ... }:
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
    packages = with pkgs; [ dconf pavucontrol ripgrep git-crypt ];
  };

  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.mako.enable = true;

  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.enableZshIntegration = true;
  services.gpg-agent.pinentry.package =
    pkgs.writeShellScriptBin "pinentry-wrapper" ''
      if [[ -z $DISPLAY ]]; then
        exec ${pkgs.pinentry-curses}/bin/pinentry "$@"
      else
        exec ${pkgs.pinentry-gnome3}/bin/pinentry "$@"
      fi
    '';

  programs.swaylock.enable = true;
  programs.cava.enable = true;
  programs.htop.enable = true;

  gtk.enable = true;
  gtk.theme = {
    name = "Adwaita-dark";
    package = pkgs.gnome-themes-extra;
  };

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
  };

  qt.enable = true;
  qt.platformTheme.name = "adwaita";
  qt.style.name = "adwaita-dark";

  programs.zathura.enable = true;

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
        "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
