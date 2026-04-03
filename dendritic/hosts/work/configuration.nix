{ self, ... }:
let host = "work";
in {
  flake.nixosConfigurations = self.lib.mkNixos "x86_64-linux" host;

  flake.modules.nixos."${host}" = { pkgs, pkgs-unstable, lib, ... }: {
    imports = with self.modules.nixos; [
      boot
      docker
      fonts
      greetd
      home-manager # The actual HM module
      hyprland
      ns
      pass
      sound
      taws
      resterm
      wgPeer
    ];

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "zoom" "slack" ];

    networking.networkmanager.enable = true;

    # for kind kubernetes cluster
    networking.firewall.checkReversePath = "loose";

    programs.nix-ld.enable = true;
    programs.gnupg.agent.enable = true;

    security.polkit.enable = true;
    security.soteria.enable = true;
  };
}
