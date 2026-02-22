{ inputs, self, lib, ... }:
let modules = self.modules;
in {
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.lib = {
    mkNixos = system: name: {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          modules.nixos.base
          modules.nixos."${name}-configuration"
          modules.nixos."${name}-hardware-configuration"
          inputs.agenix.nixosModules.default
          {
            networking.hostName = name;
            nixpkgs.hostPlatform = lib.mkDefault system;
          }
        ];
        specialArgs = {
          pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
        };
      };
    };

    mkWgInterface = peername: config:
      let
        hostname = config.networking.hostName;
        privateKeyFile =
          config.age.secrets."wireguard-${hostname}-private-key".path;

        wg = self.globals.wg;
        address = wg.peers.${hostname}.${peername}.ips;
        peers = with wg.servers.${peername}; [{
          inherit allowedIPs publicKey endpoint;
        }];
      in { ${peername} = { inherit address peers privateKeyFile; }; };
  };
}
