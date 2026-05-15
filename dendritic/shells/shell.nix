{
  perSystem = { config, pkgs, lib, inputs', ... }: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        inputs'.agenix.packages.agenix
        cachix
        nh
        deploy-rs
        nodejs_24
        uv
      ];
    };
  };
}
