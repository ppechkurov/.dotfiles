{
  flake.modules.nixos.home-configuration = { pkgs, pkgs-unstable, ... }: {
    environment.systemPackages = with pkgs; [
      docker-credential-helpers
      gcc
      git-crypt
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
