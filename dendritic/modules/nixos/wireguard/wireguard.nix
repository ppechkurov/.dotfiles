{ self, ... }: {
  flake.modules.nixos.wireguard = { globals, pkgs, lib, config, ... }:
    let
      mkWg = action:
        pkgs.writeShellScriptBin "wg-${action}" ''
          if [[ -z $1 ]]; then
            echo "Usage $(basename $0) <interface_name>"
            exit 1
          fi

          sudo systemctl "${action}" "wg-quick-$1.service"
        '';
      wg-start = mkWg "start";
      wg-stop = mkWg "stop";
    in {
      imports = with self.modules.nixos; [ tun vpn ];

      environment.systemPackages = [ wg-start wg-stop ];

      # Add all peers to /etc/hosts
      networking.hosts = let wg = self.globals.wg;
      in (lib.listToAttrs (lib.mapAttrsToList (name: peer: {
        name = builtins.elemAt (peer.tun.ips or peer.tun.allowedIPs) 0;
        value = [ "${name}.wg" ];
      }) (wg.peers // { server = wg.servers; })));
    };
}
