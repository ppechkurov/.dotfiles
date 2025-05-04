{ pkgs, ... }:
let publicKeys = (import ../../globals.nix).publicKeys.users.petrp;
in {
  imports = [
    ./hardware-configuration.nix
    ./networking.secret.nix # generated at runtime by nixos-infect
    ./services
  ];

  boot.tmp.cleanOnBoot = true;
  boot.loader.timeout = 1;
  zramSwap.enable = true;
  networking.hostName = "vps";
  networking.domain = "local";
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  users.users.root.openssh.authorizedKeys.keys = publicKeys;

  users.users.petrp = {
    description = "default nixos user";
    openssh.authorizedKeys.keys = publicKeys;
    extraGroups = [ "wheel" "nginx" "forgejo" "virtualMail" ];
    isNormalUser = true;
    shell = pkgs.bash;
  };

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

  programs.vim.enable = true;
  programs.vim.defaultEditor = true;
  environment.systemPackages = with pkgs; [ htop aerc ];

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    keyMap = "dvorak";
    font = "Lat2-Terminus16";
  };

  system.stateVersion = "23.11";
}
