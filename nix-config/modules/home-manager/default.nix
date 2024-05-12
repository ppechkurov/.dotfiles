{ osConfig, pkgs, config, lib, ... }:
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

  services = {
    mpd = {
      enable = true;
      musicDirectory = "/home/${username}/music";
    };
    mpdris2.enable = true;
    mako.enable = true;
    swayidle = let
      swaylockExe = lib.getExe config.programs.swaylock.package;
      swaymsgExe = "${pkgs.sway}/bin/swaymsg";
      walpaper = "/home/${username}/.config/sway/hackerman-wallpapers.jpg";
    in {
      enable = true;
      timeouts = [
        {
          timeout = 300;
          command =
            "${swaylockExe} --image ${walpaper} --daemonize --ignore-empty-password";
        }
        {
          timeout = 600;
          command = "${swaymsgExe} 'output * dpms off'";
          resumeCommand = "${swaymsgExe} 'output * dpms on'";
        }
      ];
    };
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };

  programs.swaylock.enable = true;
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

