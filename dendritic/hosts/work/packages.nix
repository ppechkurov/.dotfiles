{ inputs, ... }: {
  flake.modules.nixos.work = { pkgs, pkgs-unstable, ... }: {
    # needed for a custom keyboard
    services.udev.packages = with pkgs; [ qmk-udev-rules vial ];

    networking.wg-quick.interfaces.bluevps.autostart = false;
    networking.wg-quick.interfaces.webdock.autostart = false;

    environment.systemPackages = let
      system = pkgs.stdenv.hostPlatform.system;
      noctalia = inputs.noctalia.packages.${system}.default;
      # jira = inputs.jira.packages.${system}.default;
    in with pkgs; [
      chromium
      docker-credential-helpers
      gcc
      git-crypt
      # jira
      lazydocker
      noctalia
      pkgs-unstable.comma
      pkgs-unstable.jellyfin-media-player
      pkgs-unstable.mattermost-desktop
      tessen
      wiremix
    ];
  };
}
