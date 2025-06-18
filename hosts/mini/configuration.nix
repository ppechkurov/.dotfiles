{ inputs, globals, lib, config, pkgs, pkgs-unstable, ... }:
# let publicKeys = globals.publicKeys.users.${config.username}; in
{
  imports = [ ../../modules/nixos/wireguard ./hardware-configuration.nix ];

  # TODO: move to some common module
  options = with lib; {
    username = mkOption {
      type = types.str;
      default = "petrp";
    };
    monitor = mkOption { type = types.attrsOf types.anything; };
  };

  config = {
    # declare hostname
    networking.hostName = "mini";
    local.wireguard.enable = false;
    # services.syncthing.enable = true;
    # services.gatus.enable = true;
    services.soft-serve.enable = true;

    services.openssh.enable = true;

    environment.systemPackages = with pkgs; [ fzf git ];
    # users.users.root.openssh.authorizedKeys.keys = publicKeys;

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

    time.timeZone = lib.mkForce "Europe/Minsk";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    console = {
      keyMap = "dvorak";
      font = "Lat2-Terminus16";
    };

    services.openssh.settings.PasswordAuthentication = false;

    programs.zsh.enable = true;
    users.users.${config.username} = {
      description = "default nixos user";
      extraGroups = [ "wheel" "disk" ];
      isNormalUser = true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/8sFXfWRrIE+n4TtvawXjd1QKIYadM2OR9PGOxHKrP home"
      ];
      # openssh.authorizedKeys.keys = publicKeys;
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

    home-manager = {
      users.${config.username} = import ./home.nix;
      extraSpecialArgs = {
        inherit inputs;
        inherit pkgs-unstable;
      };
    };

    system.stateVersion = "25.05";
  };
}
