{ self, ... }:
let host = "home";
in {
  flake.nixosConfigurations = self.lib.mkNixos "x86_64-linux" host;

  flake.modules.nixos."${host}" = { lib, pkgs, pkgs-unstable, ... }: {
    imports = with self.modules.nixos; [
      fonts
      greetd
      home-manager # The actual HM module
      hyprland
      ns
      nvidia
      pass
      printers
      resterm
      sound
      steam
      taws
      wgPeer
    ];

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "broadcom-bt-firmware"
        "b43-firmware"
        "xow_dongle-firmware"
        "facetimehd-calibration"
        "facetimehd-firmware"

        "canon-cups-ufr2"
        "steam"
        "steam-unwrapped"
      ];

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
