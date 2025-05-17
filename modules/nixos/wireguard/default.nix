{ globals, pkgs, lib, config, ... }:
let
  wg = globals.wg;

  mkWg = action:
    pkgs.writeShellScriptBin "wg-${action}" ''
      sudo systemctl ${action} wg-quick-wg0.service
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
    }) (wg.peers // { server = wg.server; })));
}
