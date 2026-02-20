{
  flake.modules.nixos.unfree = { lib, ... }: {
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
  };
}
