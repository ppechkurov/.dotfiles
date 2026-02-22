{
  perSystem = { config, pkgs, inputs', ... }: {
    devShells.default = pkgs.mkShell {
      packages = [ inputs'.agenix.packages.agenix pkgs.nh pkgs.deploy-rs ];
    };
  };
}
