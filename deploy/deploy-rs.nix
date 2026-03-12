{ inputs, self, ... }: {
  flake.deploy.nodes = let
    system = "x86_64-linux";

    mkDeployNode = { name, hostname ? name, sshUser ? "root" }: {
      ${name} = {
        inherit hostname;
        profiles.system = {
          inherit sshUser;
          path = inputs.deploy-rs.lib.${system}.activate.nixos
            self.nixosConfigurations.${name};
        };
      };
    };
  in mkDeployNode {
    name = "mini";
    hostname = "mini.wg";
  } // mkDeployNode { name = "webdock"; } // mkDeployNode { name = "bluevps"; };
}
