{ self, ... }: {
  flake.modules.nixos.wireguard = { globals, pkgs, lib, config, ... }:
    let
      mkWg = action:
        pkgs.writeShellScriptBin "wg-${action}" ''
          action=$1
          if [[ -z $action ]]; then
            echo "Usage $(basename $0) <interface_name>"
            exit 1
          fi

          pkexec systemctl "${action}" "wg-quick-$action.service"
        '';
      wg-start = mkWg "start";
      wg-stop = mkWg "stop";
    in {
      environment.systemPackages = [ wg-start wg-stop ];

      # Add all peers to /etc/hosts
      networking.hosts = let wg = self.globals.wg;
      in (lib.listToAttrs (lib.mapAttrsToList (name: peer: {
        name = peer.interfaces.tun.ip;
        value = [ "${name}.wg" ];
      }) (wg.peers // { server = wg.servers; })));
    };
}
