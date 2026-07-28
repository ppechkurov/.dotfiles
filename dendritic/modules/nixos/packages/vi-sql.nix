{
  flake.modules.nixos.vi-sql = { pkgs, ... }:
    let
      vi-sql = pkgs.buildGoModule rec {
        pname = "vi-sql";
        version = "v0.1.4";

        src = pkgs.fetchFromGitHub {
          owner = "kopecmaciej";
          repo = "vi-sql";
          tag = version;
          hash = "sha256-At3ERFuTyfkhzi12xiLd4XrmyMfgaG5hnvXbEVh6ZKA=";
        };

        vendorHash = "sha256-sMaX1lfBK6SYxQ79Tz5c++Lfe31uCzksH4sR/4ga5pM=";

        doCheck = false;
      };
    in { environment.systemPackages = [ vi-sql ]; };
}
