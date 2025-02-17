{ config, lib, pkgs, pkgs-unstable, ... }:
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
      channel.enable = false;
    };

    # To prevent getting stuck at shutdown
    systemd.extraConfig = "DefaulTimeoutStopSec=10s";

    # Set your time zone.
    time.timeZone = lib.mkDefault "Europe/Minsk";

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
          user = config.username;
          command =
            "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        };
      };

      dbus.packages = [ pkgs.gcr ];
    };

    # this is a life saver.
    # literally no documentation about this anywhere.
    # might be good to write about this...
    # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
    # found [here](https://github.com/sjcobb2022/nixos-config/blob/main/hosts/common/optional/greetd.nix)
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam on screen
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };

    # pipewire
    security.rtkit.enable = true;
    security.polkit.enable = true;

    security.pam.services.hyprlock = { };

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
        dina-font
        fira-code
        fira-code-symbols
        font-awesome
        liberation_ttf
        mplus-outline-fonts.githubRelease
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        powerline-fonts
        powerline-symbols
        proggyfonts
        greetd.tuigreet
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

    programs.ssh.startAgent = true;
    programs.ssh.extraConfig = # bash
      ''
        Host github.com
          IdentitiesOnly yes
          User git
          Hostname github.com
          PreferredAuthentications publickey
          IdentityFile /home/${config.username}/.ssh/id_ed25519
      '';

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
      ncdu
      neovide
      nodejs_22
      pass-wayland
      satty
      slurp
      tessen
      unzip
      transmission_4-qt
      vim
      xkeyboard_config

      pkgs-unstable.codeium
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
      XDG_SESSION_TYPE = "wayland";

      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      config = { common.default = [ "gtk" "wlr" "hyprland" ]; };
    };

    programs.hyprland.enable = true;
    programs.hyprland.package = pkgs-unstable.hyprland;
    programs.hyprland.xwayland.enable = true;
    programs.hyprland.portalPackage = pkgs.xdg-desktop-portal-hyprland;

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

