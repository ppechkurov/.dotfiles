{ self, ... }:
let host = "work";
in {
  flake.nixosConfigurations = self.lib.mkNixos "x86_64-linux" host;

  flake.modules.nixos."${host}" = { pkgs, pkgs-unstable, lib, ... }: {
    imports = with self.modules.nixos; [
      aerc
      docker
      fonts
      gh
      greetd
      home-manager # The actual HM module
      hyprland
      ns
      pass
      sound
      tofi
      wgPeer
    ];

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "zoom" "slack" ];

    networking.networkmanager.enable = true;

    programs.nix-ld.enable = true;
    programs.gnupg.agent.enable = true;

    security.polkit.enable = true;
    security.soteria.enable = true;
  };
}
