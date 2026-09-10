{
  flake.modules.nixos.e1s =
    { pkgs, ... }:
    let
      e1s = pkgs.buildGo126Module rec {
        pname = "e1s";
        version = "v2.0.0-rc.5";

        src = pkgs.fetchFromGitHub {
          owner = "keidarcy";
          repo = "e1s";
          tag = version;
          hash = "sha256-nA6xQtW9qpBF0F9ayPPWl8KdQYKKM5m3bMeXF7gS8NE=";
        };

        vendorHash = "sha256-97s919zXWlYhjz7beQOaU7Plm3QtBpn1QFbVXlinnDs=";
      };
    in
    {
      environment.systemPackages = [ e1s ];
    };
}
