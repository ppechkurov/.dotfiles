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

        hyprland
      ];

      networking.networkmanager.enable = true;

      programs.nix-ld.enable = true;

      environment.systemPackages = with pkgs; [
        gcc
        docker-credential-helpers
        jellyfin-ffmpeg
        jmtpfs # mount android devices, see https://nixos.wiki/wiki/MTP
        lazydocker
        pkgs-unstable.mattermost-desktop
        pass-wayland
        tessen
      ];
    };
}
