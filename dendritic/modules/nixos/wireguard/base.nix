{ self, ... }: {
  flake.modules.nixos.wireguard = { globals, pkgs, lib, config, ... }:
    let
      mkWg = action:
        pkgs.writeShellScriptBin "wg-${action}" ''
          if [[ -z $1 ]]; then
            echo "Usage $(basename $0) <interface_name>"
            exit 1
          fi

          # if it's tty just use sudo
          if [ -t 1 ]; then
            sudo systemctl "${action}" "wg-quick-$1.service"
            exit 0
          fi

          # fancy prompt if run from gui
          count=1
          while ! ${lib.getExe pkgs.zenity} --password --title "sudo password" |
            sudo -S systemctl "${action}" "wg-quick-$1.service" ; do
            if [ $count -ge 3 ]; then
              ${lib.getExe pkgs.zenity} --error --text "Unable to proceed"
              break
            fi

            count=$(expr $count + 1)
          done
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
