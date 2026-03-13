{ self, ... }:
let host = "kirillp";
in {
  flake.nixosConfigurations = self.lib.mkNixos "x86_64-linux" host;

  flake.modules.nixos."${host}" = { lib, pkgs, pkgs-unstable, ... }: {
    imports = with self.modules.nixos; [
      boot
      fonts
      greetd
      home-manager # The actual HM module
      hyprland
      ns
      sound
      steam
    ];

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "b43-firmware"
        "broadcom-bt-firmware"
        "steam"
        "steam-unwrapped"
        "xow_dongle-firmware"
      ];

    programs.nix-ld.enable = true;

    security.polkit.enable = true;
    security.soteria.enable = true;

    time.timeZone = "Europe/Minsk";
  };
}
