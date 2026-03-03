{ self, ... }:
let system = "home";
in {
  flake.nixosConfigurations = self.lib.mkNixos "x86_64-linux" system;

  flake.modules.nixos."${system}-configuration" =
    { lib, pkgs, pkgs-unstable, ... }: {
      imports = with self.modules.nixos; [
        docker
        fonts
        greetd
        home-manager # The actual HM
        hyprland
        ns
        nvidia
        pass
        printers
        self.modules.nixos."${system}-networking"
        self.modules.nixos."${system}-services"
        sound
        steam
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

      networking.networkmanager.enable = true;

      programs.nix-ld.enable = true;
      programs.gnupg.agent.enable = true;

      security.polkit.enable = true;
      security.soteria.enable = true;

      time.timeZone = "Europe/Minsk";
    };
}
