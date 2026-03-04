{ inputs, ... }: {
  flake.modules.nixos.home = { pkgs, pkgs-unstable, ... }: {
    environment.systemPackages = with pkgs;
      let
        system = pkgs.stdenv.hostPlatform.system;
        noctalia = inputs.noctalia.packages.${system}.default;
      in [
        gcc
        git-crypt
        noctalia
        jellyfin-ffmpeg
        jmtpfs # mount android devices, see https://nixos.wiki/wiki/MTP
        lazydocker
        pkgs-unstable.comma
        pkgs-unstable.jellyfin-media-player
        pkgs-unstable.mattermost-desktop
        tessen
        wiremix
      ];
  };
}
