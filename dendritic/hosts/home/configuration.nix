{ self, ... }:
let system = "home";
in {
  flake.nixosConfigurations = self.lib.mkNixos "x86_64-linux" system;

  flake.modules.nixos."${system}-configuration" =
    { pkgs, pkgs-unstable, ... }: {
      imports = with self.modules.nixos; [
        home-manager

        fonts
        greetd
        sound

        hyprland
      ];
    };
}
