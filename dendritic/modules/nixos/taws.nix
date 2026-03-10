{
  flake.modules.nixos.taws = { pkgs, ... }:
    let
      taws = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
        pname = "taws";
        version = "v1.3.0-rc.7";

        src = pkgs.fetchFromGitHub {
          owner = "huseyinbabal";
          repo = "taws";
          tag = finalAttrs.version;
          hash = "sha256-oxahcQp14ooQ8pIOcaaf0IQRkuASl4grLulGKUKSKcw=";
        };

        cargoHash = "sha256-7zZ2JJVQem2R072sefv2oB9mmQcRuUHVKKcb+HEnm6Y=";
      });
    in { environment.systemPackages = [ taws ]; };
}
