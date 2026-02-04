{
  flake.nixosModules.nix = {
    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
        trusted-substituters =
          [ "https://cache.nixos.org/" "https://ppechkurov.cachix.org" ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "ppechkurov.cachix.org-1:ChzUYtQ6adSICkzYQ9LznJpeIm/a2oeQh3SVjXXZnPg="
        ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      channel.enable = false;
    };
  };
}
