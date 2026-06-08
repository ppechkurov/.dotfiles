{
  inputs,
  self,
  lib,
  ...
}:
let
  modules = self.modules;
in
{
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.lib = {
    mkNixos =
      {
        system,
        name,
        nixpkgs ? inputs.nixpkgs,
        hmInput ? null,
      }:
      let
        baseSpecialArgs = {
          pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
        };
        specialArgs = if hmInput != null
          then baseSpecialArgs // { inherit hmInput; }
          else baseSpecialArgs;
      in
      {
        ${name} = nixpkgs.lib.nixosSystem {
          modules = [
            modules.nixos.base
            modules.nixos."${name}"
            inputs.agenix.nixosModules.default
            {
              networking.hostName = name;
              nixpkgs.hostPlatform = lib.mkDefault system;
            }
          ];
          inherit specialArgs;
        };
      };

    mkHomeManagerUser = system: name: {
      ${name} = {
        imports = [ inputs.self.modules.homeManager.cli ];
      };
    };

    mkWgInterface =
      name: hostname: privateKeyFilePath:
      let
        wg = self.globals.wg;
        peerIface = wg.peers.${hostname}.interfaces.${name};
        serverIface = wg.servers.interfaces.${name};
      in
      {
        ${name} = {
          address = [ peerIface.ip ];
          autostart = lib.mkDefault serverIface.autostart or true;
          peers = with serverIface; [
            {
              inherit allowedIPs publicKey endpoint;
              persistentKeepalive = 15;
            }
          ];
          privateKeyFile = privateKeyFilePath;
        };
      };
  };
}
