{
  flake.modules.nixos.resterm = { pkgs, ... }:
    let
      resterm = pkgs.buildGoModule rec {
        pname = "resterm";
        version = "v0.23.6";

        src = pkgs.fetchFromGitHub {
          owner = "unkn0wn-root";
          repo = "resterm";
          tag = version;
          hash = "sha256-MVcLyPPnQIn0IZcGOoELRSQkI+BEIXSZfWeeZv6AILI=";
        };

        vendorHash = "sha256-3BSvjt9fprjin5kbDJK1cPkzys1BH8iDEIex9WdDo8s=";
      };
    in { environment.systemPackages = [ resterm ]; };
}
