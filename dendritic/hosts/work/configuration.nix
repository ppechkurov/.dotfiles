{ self, ... }:
let system = "work";
in {
  flake.nixosConfigurations = self.lib.mkNixos "x86_64-linux" system;

  flake.modules.nixos."${system}-configuration" =
    { pkgs, pkgs-unstable, lib, ... }: {
      imports = with self.modules.nixos; [
        docker
        fonts
        greetd
        home-manager
        hyprland
        ns
        pass
        sound
      ];

      nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [ "zoom" "slack" ];

      networking.networkmanager.enable = true;
      programs.nix-ld.enable = true;
    };
}
