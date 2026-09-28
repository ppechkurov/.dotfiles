{
  flake.modules.nixos.e1s =
    { pkgs, ... }:
    let
      e1s = pkgs.buildGo126Module rec {
        pname = "e1s";
        version = "v2.0.0";

        src = pkgs.fetchFromGitHub {
          owner = "keidarcy";
          repo = "e1s";
          tag = version;
          hash = "sha256-bOG6txoreiP/buYO3rvcxhL1yAxlECkbwf9FqvWLz9k=";
        };

        vendorHash = "sha256-vVUuoAsoxVKDGxLOQBjOx56IiPWBbtYBJbJNq+kPV7A=";
      };
    in
    {
      environment.systemPackages = [ e1s ];
    };
}
