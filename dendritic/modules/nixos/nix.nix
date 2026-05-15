{
  flake.modules.nixos.nix = { pkgs, ... }: {
    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
        substituters = [
          "https://cache.nixos.org"
          "https://niri.cachix.org"
          "https://vicinae.cachix.org"
        ];

        trusted-substituters =
          [ "https://cache.nixos.org/" "https://ppechkurov.cachix.org" ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
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
