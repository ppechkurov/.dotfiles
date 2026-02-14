{ self, ... }: {
  flake.nixosConfigurations = self.lib.mkNixos "x86_64-linux" "home";

  flake.modules.nixos.home-configuration = { pkgs, pkgs-unstable, ... }: {
    imports = with self.modules.nixos; [
      home-manager

      fonts
      greetd
      sound

      hyprland
    ];
  };
}
