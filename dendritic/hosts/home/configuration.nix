{ self, inputs, ... }:
let system = "home";
in {
  flake.nixosConfigurations = self.lib.mkNixos "x86_64-linux" system;

  flake.modules.nixos."${system}-configuration" =
    { lib, pkgs, pkgs-unstable, ... }: {
      imports = with self.modules.nixos; [
        docker
        fonts
        greetd
        home-manager
        home-networking
        home-services
        hyprland
        nvidia
        printers
        sound
        steam
        unfree
        wireguard
        inputs.dms.nixosModules.dank-material-shell
      ];

      environment.systemPackages =
        [ inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default ];

      networking.networkmanager.enable = true;

      programs.nix-ld.enable = true;
      programs.gnupg.agent.enable = true;

      security.polkit.enable = true;

      time.timeZone = "Europe/Minsk";
    };
}
