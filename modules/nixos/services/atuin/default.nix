{ globals, ... }:
let wgServerIp = globals.wg.servers.networks.tun.ipv4;
in {
  services.atuin = {
    host = wgServerIp; # doesn't work with localhost, not sure why
    # incoming traffic should be from a trusted device, e.g. tun, don't need to open ports
    openFirewall = false;
    openRegistration = true;
  };
}
