{ globals, pkgs, lib, config, ... }:
let
  wg = globals.wg;

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
  cfg = config.local.wireguard;
in {
  imports = [ ./options.nix ./server.nix ./peer.nix ];
  environment.systemPackages = [ wg-start wg-stop ];

  # Add all peers to /etc/hosts
  networking.hosts = lib.mkIf (cfg.enable || cfg.server.enable) (lib.listToAttrs
    (lib.mapAttrsToList (name: peer: {
      name = peer.networks.tun.ipv4;
      value = [ "${name}.local.wg" ];
    }) (wg.peers // { server = wg.servers; })));
}
