{
  flake.modules.nixos.tfui = { pkgs, ... }:
    let
      tfui = pkgs.buildGo126Module rec {
        pname = "tfui";
        version = "v0.3.0";

        src = pkgs.fetchFromGitHub {
          owner = "SayYoungMan";
          repo = "tfui";
          tag = version;
          hash = "sha256-WFTRaVnGBSdQvbVWxNcKEUo3KsebOFcWMmUeBXkEGSA=";
        };

        vendorHash = "sha256-Y70o5PA1O/RTDTs9GphFPuO/9//FBi8QmPwDeDgl+x4=";
      };
    in { environment.systemPackages = [ tfui ]; };
}

