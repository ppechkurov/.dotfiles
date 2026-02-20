{ self, inputs, ... }:
let system = "home";
in {
  flake.nixosConfigurations = self.lib.mkNixos "x86_64-linux" system;

  flake.modules.nixos."${system}-configuration" =
    { pkgs, pkgs-unstable, ... }: {
      imports = with self.modules.nixos; [
        home-manager
        docker

        fonts
        greetd
        sound
        home-networking
        nvidia

        unfree
        steam
        printers

        hyprland
      ];

      networking.networkmanager.enable = true;

      programs.nix-ld.enable = true;

      environment.systemPackages = with pkgs; [
        docker-credential-helpers
        gcc
        jellyfin-ffmpeg
        jmtpfs # mount android devices, see https://nixos.wiki/wiki/MTP
        lazydocker
        pass-wayland
        pkgs-unstable.comma
        pkgs-unstable.jellyfin-media-player
        pkgs-unstable.mattermost-desktop
        tessen
      ];
    };
}
