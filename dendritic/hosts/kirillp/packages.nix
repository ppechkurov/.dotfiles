{ inputs, ... }: {
  flake.modules.nixos.kirillp = { pkgs, pkgs-unstable, ... }: {
    environment.systemPackages = let
      system = pkgs.stdenv.hostPlatform.system;
      noctalia = inputs.noctalia.packages.${system}.default;
    in with pkgs; [
      noctalia
      jellyfin-ffmpeg
      jmtpfs # mount android devices, see https://nixos.wiki/wiki/MTP
      pkgs-unstable.jellyfin-media-player
      pkgs-unstable.mattermost-desktop
      wiremix
    ];
  };
}
