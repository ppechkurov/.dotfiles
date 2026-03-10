{
  perSystem = { config, pkgs, lib, inputs', ... }: {
    devShells.default = pkgs.mkShell {
      packages = let
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
      in [ inputs'.agenix.packages.agenix pkgs.nh pkgs.deploy-rs taws ];
    };
  };
}
