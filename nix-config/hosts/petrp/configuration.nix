{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable Experimental Features and Package Management
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
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

  # Enable Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

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

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd sway";
          user = "greeter";
        };
      };
    };
  };

  # pipewire
  security.rtkit.enable = true;
  security.polkit.enable = true;
  
  # OpenGL
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  # Fonts
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
      };
    };
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Iosevka" "IosevkaTerm" "ShareTechMono" ]; })
      font-awesome
      powerline-fonts
      powerline-symbols
    ];
  };

  # User account
  users.users.petrp = {
    isNormalUser = true;
    description = "petrp";
    extraGroups = [ "networkmanager" "wheel" "disk" "power" "video" ];
    shell = pkgs.zsh;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      petrp = import ./home.nix { inherit pkgs; username = "petrp"; };
    };
  };

  # Allow unfree packages and insecure packages
  nixpkgs.config.allowUnfree = true;

  # Configure programs
  programs = {
    # Shell
    zsh.enable = true;
  };
  
  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
   vim
   curl
   git
  ];

  environment.pathsToLink = [ "/share/zsh" ];
  environment.sessionVariables = {
    TERMINAL = "foot";
    NIXOS_OZONE_WL = "1";
  };

  # xdg
  xdg.portal = {
    enable = true;
    config.common.default = [ "gtk" ];
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      # xdg-desktop-portal-hyprland
      # xdg-desktop-portal-gtk
    ];
    wlr.enable = true;
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
}
