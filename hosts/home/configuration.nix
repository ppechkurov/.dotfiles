{ inputs, lib, config, pkgs, pkgs-unstable, globals, ... }:
let
  mkSyncNotifyService = status: message: {
    enable = true;
    description = "Notify on restic sync ${status}";
    serviceConfig = {
      Type = "oneshot";
      User = "petrp";
    };
    script = "${lib.getExe pkgs.mattermost-send} '${message}' ${status}";
  };
in {
  imports = [
    ../../modules/nixos/common
    ../../modules/nixos/nvidia
    ../../modules/nixos/wireguard
    ../../modules/nixos/networks/kubernetes.nix
    ../../modules/nixos/services/syncthing.nix
    ../../modules/nixos/services/gatus.nix
    ../../modules/nixos/services/mattermost
    ./hardware-configuration.nix
  ];

  # declare hostname
  networking.hostName = "home";

  networking.interfaces.enp5s0.wakeOnLan = {
    enable = true;
    policy = [ "magic" ];
  };

  local.wireguard.enable = true;
  # services.syncthing.enable = true;
  # services.gatus.enable = true;
  # services.soft-serve.enable = true;

  # services.immich.enable = true;
  # services.photoprism.enable = true;
  # services.photoprism.originalsPath = "/data/photos";
  # services.photoprism.settings = {
  #   PHOTOPRISM_ADMIN_USER = "admin";
  #   PHOTOPRISM_ADMIN_PASSWORD = "aoeu";
  # };

  networking.hosts = { "192.168.100.14" = [ "mini.local.home" ]; };

  # Uncomment this if you want to play with the kube again.
  # specialisation.kuber = {
  #   inheritParentConfig = true;
  #   configuration = {
  #     system.nixos.tags = [ "kuber" ];
  #     local.kube.networks.enable = true;
  #   };
  # };

  monitor = {
    "Virtual-1" = { mode = "1680x1050@59.954Hz"; };
    "*" = { bg = "hackerman-wallpapers.jpg fill"; };
  };

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ canon-cups-ufr2 gutenprint ];

  services.openssh.enable = true;

  environment.systemPackages = with pkgs;
    let gostman = inputs.gostman.packages.${pkgs.system}.default;
    in [
      cachix
      gostman
      jellyfin-media-player
      mattermost-send
      pkgs-unstable.comma
      protonup
      steam-run
      vial
    ];

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  programs.nix-ld.enable = true;
  programs.niri.enable = true;
  programs.niri.package = pkgs-unstable.niri;

  services.udev.packages = with pkgs; [ qmk-udev-rules vial ];

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
    extraSpecialArgs = { inherit inputs pkgs-unstable globals; };
  };

  systemd.services.sync-restic-repo = {
    enable = true;
    description = "Sync restic backup repo";
    serviceConfig = {
      Type = "oneshot";
      User = "petrp";
    };
    path = [ pkgs.openssh pkgs.rclone ];

    script = # bash
      ''
        rclone sync mini:/mnt/hdd/restic $HOME/restic
      '';
  };

  systemd.timers.sync-restic-repo = {
    enable = true;
    description = "Daily sync of restic backup repo at midnight";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "sync-restic-repo.service";
    };
  };

  systemd.services.sync-restic-repo.unitConfig = {
    OnSuccess = "notify-sync-success.service";
    OnFailure = "notify-sync-failure.service";
  };

  systemd.services.notify-sync-success = let
    message = ''
      **Sync Job Successful**

      Host: `${config.networking.hostName}`.

      Sync job completed successfuly!
    '';
  in mkSyncNotifyService "success" message;

  systemd.services.notify-sync-failure = let
    message = ''
      **Sync Job Failed**

      Host: `${config.networking.hostName}`.

      Sync job has been failed!
    '';
  in mkSyncNotifyService "failure" message;
}
