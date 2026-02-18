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
