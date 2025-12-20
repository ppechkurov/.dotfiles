{ inputs, pkgs, ... }:
let
  ghostty = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  programs.ghostty.enable = true;
  programs.ghostty = {
    package = ghostty;
    enableZshIntegration = true;
    settings = { theme = "GruvboxDard"; };
  };

  nix.settings = {
    trusted-substituters = [ "https://ghostty.cachix.org" ];
    trusted-public-keys =
      [ "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns=" ];
  };
}

