{ inputs, lib, config, pkgs, pkgs-unstable, ... }: {
  imports = [ ./hardware-configuration.nix ];

  # declare hostname
  networking.hostName = "kirill";

  networking.hosts = { "192.168.100.14" = [ "mini.local.home" ]; };

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    pkgs-unstable.hyprland-per-window-layout
    pkgs-unstable.jellyfin-media-player
    protonup-ng
    steam-run
    vial
  ];

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  programs.nix-ld.enable = true;

  time.timeZone = lib.mkForce "Europe/Minsk";

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluez;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  hardware.enableAllFirmware = true;

  home-manager = {
    users.${config.username} = import ./home.nix;
    extraSpecialArgs = { inherit inputs pkgs-unstable; };
  };
}
