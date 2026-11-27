{ self, ... }:
let
  host = "home";
in
{
  flake.nixosConfigurations = self.lib.mkNixos {
    system = "x86_64-linux";
    name = host;
  };

  flake.modules.nixos."${host}" =
    {
      lib,
      pkgs,
      pkgs-unstable,
      ...
    }:
    {
      imports = with self.modules.nixos; [
        boot
        docker
        fonts
        greetd
        home-manager # The actual HM module
        hyprland
        niri
        ns
        nvidia
        pass
        printers
        sound
        steam
        taws
        tuicr
        wgPeer
      ];

      services.udev.extraRules = ''
        # DualShock 4 (PS4) - USB and Bluetooth
        KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0660", TAG+="uaccess"
        KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0660", TAG+="uaccess"
        KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ba0", MODE="0660", TAG+="uaccess"
      '';

      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "nvidia-x11"
          "nvidia-kernel-modules"
          "broadcom-bt-firmware"
          "b43-firmware"
          "xow_dongle-firmware"
          "xone-dongle-firmware"
          "facetimehd-calibration"
          "facetimehd-firmware"

          "canon-cups-ufr2"
          "steam"
          "steam-unwrapped"
        ];

      # for kind kubernetes cluster
      networking.firewall.checkReversePath = "loose";

      # networking.firewall.enable = false;
      networking.hosts = {
        "172.18.0.100" = [
          "login.flosum.local" # #
          "gs.flosum.local"
        ];
      };

      networking.wg-quick.interfaces.bluevps.autostart = true;
      networking.wg-quick.interfaces.webdock.autostart = false;

      networking.networkmanager.enable = true;

      programs.nix-ld.enable = true;
      programs.gnupg.agent.enable = true;

      security.polkit.enable = true;
      security.soteria.enable = true;

      time.timeZone = "Europe/Minsk";
    };
}
