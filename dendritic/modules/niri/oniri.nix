{
  flake.modules.nixos.oniri = { pkgs, ... }: {
    environment.systemPackages = [
      (pkgs.rustPlatform.buildRustPackage (finalAttrs: {
        pname = "oniri";
        version = "1.2.2";

        src = pkgs.fetchFromGitHub {
          owner = "Antiz96";
          repo = "oniri";
          tag = "v${finalAttrs.version}";
          hash = "sha256-ezSyNY21NgeR067E7tmw29SazBUt+hYpsPavOpPt3L4=";
        };

        cargoHash = "sha256-ue08WszHwDbnXRR3lxcwCrtC2XMpg55BXcj65tS3u1E=";

        nativeBuildInputs = [ pkgs.scdoc ];

        postInstall = ''
          scdoc < doc/man/oniri.1.scd > oniri.1
          install -Dm644 oniri.1 -t $out/share/man/man1/
        '';
      }))
    ];
  };
}
