{ self, ... }:
let system = "work";
in {
  flake.nixosConfigurations = self.lib.mkNixos "x86_64-linux" system;

  flake.modules.nixos."${system}-configuration" =
    { pkgs, pkgs-unstable, lib, ... }: {
      imports = with self.modules.nixos; [
        home-manager
        docker

        fonts
        greetd
        sound

        hyprland
      ];

      networking.networkmanager.enable = true;
      programs.nix-ld.enable = true;

      nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [ "zoom" "slack" ];

      environment.systemPackages = with pkgs; [
        docker-credential-helpers
        grim
        pkgs-unstable.flameshot
        jellyfin-ffmpeg
        jmtpfs # mount android devices, see https://nixos.wiki/wiki/MTP
        lazydocker
        pkgs-unstable.mattermost-desktop
        pass-wayland
        tessen
      ];
    };
}
