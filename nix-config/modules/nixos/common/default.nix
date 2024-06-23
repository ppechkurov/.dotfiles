{ config, lib, pkgs, inputs, ... }:
with lib; {
  options = {
    username = mkOption {
      type = types.str;
      default = "petrp";
    };
    monitor = mkOption { type = types.attrsOf types.anything; };
  };

  config = {
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Enable Experimental Features and Package Management
    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };

    # To prevent getting stuck at shutdown
    systemd.extraConfig = "DefaulTimeoutStopSec=10s";

    # Set your time zone.
    time.timeZone = "Europe/Minsk";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    console = {
      keyMap = "dvorak";
      font = "Lat2-Terminus16";
    };

    # Services
    services = {
      # Sound with pipewire
      pipewire = {
        enable = true;
        pulse.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
      };

      # TTY login
      greetd = {
        enable = true;
        settings.default_session = {
          user = "greeter";
          command =
            "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        };
      };

      dbus.packages = [ pkgs.gcr ];
    };

    # pipewire
    security.rtkit.enable = true;
    security.polkit.enable = true;

    security.pam.services.hyprlock = { };

    # OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    # Docker
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };

    # Fonts
    fonts = {
      fontconfig = {
        enable = true;
        defaultFonts = { monospace = [ "JetBrainsMono Nerd Font" ]; };
      };
      packages = with pkgs; [
        (nerdfonts.override {
          fonts = [ "VictorMono" "JetBrainsMono" "ShareTechMono" ];
        })
        font-awesome
        powerline-fonts
        powerline-symbols
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        liberation_ttf
        fira-code
        fira-code-symbols
        mplus-outline-fonts.githubRelease
        dina-font
        proggyfonts
      ];
    };

    # User account
    programs.zsh.enable = true;
    users.users.${config.username} = {
      description = "default nixos user";
      extraGroups = [ "networkmanager" "wheel" "disk" "power" "video" ];
      isNormalUser = true;
      shell = pkgs.zsh;
    };

    networking.networkmanager.enable = true;

    # Allow unfree packages and insecure packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile.
    environment.systemPackages = with pkgs; [
      alsa-utils
      curl
      docker-credential-helpers
      flameshot
      git
      grim
      jellyfin-ffmpeg
      jmtpfs # mount android devices, see https://nixos.wiki/wiki/MTP
      jq
      killall
      lazydocker
      libnotify
      libreoffice
      mpc-cli
      neovide
      nodejs_20
      pass-wayland
      satty
      skypeforlinux
      slack
      slurp
      steam-run
      tessen
      unzip
      transmission-qt
      vim
      xkeyboard_config

      (import inputs.nixpkgs-unstable {
        system = "x86_64-linux";
        config = { allowUnfree = true; };
      }).codeium
    ];

    environment.pathsToLink = [ "/share/zsh" ];
    environment.sessionVariables = {
      CLUTTER_BACKEND = "wayland";
      DISABLE_QT5_COMPAT = "0";
      GDK_BACKEND = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      TERMINAL = "foot";
      WLR_NO_HARDWARE_CURSORS = "1";
      XDG_SESSION_TYPE = "wayland";

      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
        xdg-desktop-portal-hyprland
      ];
      config = { common.default = [ "gtk" "wlr" "hyprland" ]; };
    };

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.11"; # Did you read the comment?
  };
}

