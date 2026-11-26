{
  flake.modules.nixos.sqlmux =
    { pkgs, ... }:
    let
      sqlmux = pkgs.buildGoModule {
        pname = "sqlmux";
        version = "v0.12.0";

        src = pkgs.fetchFromGitHub {
          owner = "kackerx";
          repo = "sqlmux";
          rev = "d7559825be124968de83b9074b69dd0a5a161adc";
          hash = "sha256-XoyKZkL0f3ddFC2za4BuaEu/S/zq2o8xyTqOeMP/rxk=";
        };

        vendorHash = "sha256-ncIyvmQde9HQmC5XHRucnyj0DofWZx0QPTWGKvet2/8=";

        doCheck = false;
      };
    in
    {
      environment.systemPackages = [ sqlmux ];
    };
}
