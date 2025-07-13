{ inputs, globals, lib, config, pkgs, pkgs-unstable, ... }:
let publicKeys = globals.publicKeys.users.${config.username};
in {
  imports = [
    ../../modules/nixos/wireguard
    ../../modules/nixos/services/soft-serve
    ./hardware-configuration.nix
  ];

  # TODO: move to some common module
  options = with lib; {
    username = mkOption {
      type = types.str;
      default = "petrp";
    };
  };

  config = {
    networking.hostName = "mini";
    local.wireguard.enable = true;

    # TODO: configure when their fix for tmux is merged to the nix packages
    services.soft-serve.enable = true;

    services.jellyfin.enable = true;
    services.jellyfin = { openFirewall = true; };

    networking.interfaces.enp4s0.wakeOnLan = {
      enable = true;
      policy = [ "magic" ];
    };

    networking.firewall.allowedTCPPorts = [
      8080 # for connection test
    ];

    services.openssh.enable = true;
    services.openssh.allowSFTP = true;
    services.openssh.settings.PasswordAuthentication = false;

    environment.systemPackages = with pkgs; [
      git
      wakeonlan
      sshfs
      lm_sensors
      inetutils
    ];

    users.users.root.openssh.authorizedKeys.keys = publicKeys;

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.tmp.cleanOnBoot = true;
    boot.loader.timeout = 1;

    # Enable Experimental Features and Package Management
    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
        trusted-users = [ "@wheel" ];
        allowed-users = [ "@wheel" ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      channel.enable = false;
    };

    time.timeZone = lib.mkForce "Europe/Minsk";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    console = {
      keyMap = "dvorak";
      font = "Lat2-Terminus16";
    };

    programs.zsh.enable = true;
    users.users.${config.username} = {
      description = "default nixos user";
      extraGroups = [ "wheel" "disk" "power" "transmission" ];
      isNormalUser = true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = publicKeys ++ [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPhEZUfUL6KX4uWMR7G7b9oxPBaaucCVFrU9ULA9+c+b petrp@webdock" # to mount sshfs
      ];
    };

    programs.ssh.startAgent = true;
    home-manager = {
      users.${config.username} = import ./home.nix;
      extraSpecialArgs = { inherit inputs pkgs-unstable globals; };
    };

    system.stateVersion = "25.05";
  };
}
