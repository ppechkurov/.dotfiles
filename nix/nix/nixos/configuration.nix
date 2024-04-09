{ config, pkgs, pkgs-unstable, inputs, outputs, ... }:

let
  unstable = with pkgs-unstable; [
    neovim
  ];
  stable = with pkgs; [
  ];
in {
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    inputs.home-manager.nixosModules.home-manager
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "nixos"; # Define your hostname.
    # Enable networking
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Minsk";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us-prog";
    xkb = {
      extraLayouts = {
        us-prog = {
          description = "US Prog";
          languages = [ "eng" ];
          symbolsFile = ./us-prog;
        };
      };
    };
  };

  home-manager = {
    users = {
      petrp = import ../home-manager/home.nix;
    };
    extraSpecialArgs = { inherit inputs outputs; };
  };

  programs.zsh.enable = true;

  users.users = {
    petrp = {
      isNormalUser = true;
      hashedPassword = "$6$ATTQnc91//TUYRQH$.He6RJvD/FNRCbNXrht/hO7399SqwZzXdSnpWzVNKVTRfiJyheUBE9nnGfN7M06c0tKKEU91.Ldb4dtTYJ9fn/";
      extraGroups = ["wheel"];
      packages = [ inputs.home-manager.packages.${pkgs.system}.default ] ++ stable ++ unstable;
      shell = pkgs.zsh;
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    ];

    shellAliases = {
      ls = "ls -l";
      ll = "ls -l";
      lla = "ls -latch";
      ".." = "cd ..";
      "..." = "cd ../..";
      vim = "nvim";
    };

    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      SUDO_EDITOR = "nvim";
    };
  };


  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
