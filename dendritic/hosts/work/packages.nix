{ inputs, ... }: {
  flake.modules.nixos.work = { pkgs, pkgs-unstable, ... }: {
    environment.systemPackages = with pkgs; [
      docker-credential-helpers
      gcc
      git-crypt
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      lazydocker
      pkgs-unstable.comma
      pkgs-unstable.jellyfin-media-player
      pkgs-unstable.mattermost-desktop
      tessen
      wiremix
    ];
  };
}
