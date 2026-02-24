{
  flake.modules.nixos.ns = { pkgs, ... }: {
    environment.systemPackages = let
      ns = pkgs.writeShellApplication {
        name = "ns";
        runtimeInputs = with pkgs; [ fzf nix-search-tv ];
        text = # bash
          ''
            nix-search-tv print |
              fzf --preview 'nix-search-tv preview {}' --scheme history |
              wl-copy
          '';
      };
    in [ ns pkgs.nix-search-tv ];
  };
}
