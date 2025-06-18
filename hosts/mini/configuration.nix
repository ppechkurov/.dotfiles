{ inputs, lib, config, pkgs, pkgs-unstable, ... }: {
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

    environment.systemPackages = [ ];

    time.timeZone = lib.mkForce "Europe/Minsk";

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
