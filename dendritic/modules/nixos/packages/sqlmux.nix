{
  flake.modules.nixos.sqlmux =
    { pkgs, ... }:
    let
      sqlmux = pkgs.buildGoModule rec {
        pname = "sqlmux";
        version = "v0.6.0";

        src = pkgs.fetchFromGitHub {
          owner = "kackerx";
          repo = "sqlmux";
          tag = version;
          hash = "sha256-yvYLPIIvYh4WcmDpWfVTikVEo0rfwXJXeOqoohdNGwg=";
        };

        vendorHash = "sha256-pOsM3Azu7rBRBSQUbmlNtYRAGpB+GkwObioKrfm54aw=";

        doCheck = false;
      };
    in
    {
      environment.systemPackages = [ sqlmux ];
    };
}
