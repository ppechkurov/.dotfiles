{
  flake.modules.homeManager.lazy-tmux = { pkgs, pkgs-unstable, ... }:
    let
      lazy-tmux = pkgs-unstable.buildGo126Module {
        pname = "lazy-tmux";
        version = "v0.1.14";

        src = pkgs.fetchFromGitHub {
          owner = "alchemmist";
          repo = "lazy-tmux";
          rev = "9b781f0ba7f564397900126dcfad3304507df0f3";
          hash = "sha256-NHIJ/hY6mDcwZEPrCzZVBvXq5SxJZwed5tnZpDah35Q=";
        };

        vendorHash = "sha256-jUXpUnT+ciQEciak8AX6v9JuAxDKNQhEcJuoCuPRxis=";
      };
    in { home.packages = [ lazy-tmux ]; };
}

