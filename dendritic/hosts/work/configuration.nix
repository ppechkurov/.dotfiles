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
      opencode
      pass
      sound
      taws
      wgPeer
    ];

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "zoom" "slack" ];

    networking.networkmanager.enable = true;
    # for vpn
    # networking.enableIPv6 = false;

    # for kind kubernetes cluster
    networking.firewall.checkReversePath = "loose";

    programs.nix-ld.enable = true;
    programs.gnupg.agent.enable = true;

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;
    security.pam.services.greetd.enableGnomeKeyring = true; # adjust to your DM

    security.polkit.enable = true;
    security.soteria.enable = true;
  };
}
