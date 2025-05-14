{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    defaultGateway = "169.254.255.1";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [{
          address = "193.180.208.246";
          prefixLength = 32;
        }];
        ipv6.addresses = [
          {
            address = "2a0f:f01:207:f7::";
            prefixLength = 124;
          }
          {
            address = "fe80::1266:6aff:feae:e3d3";
            prefixLength = 64;
          }
        ];
        ipv4.routes = [{
          address = "169.254.255.1";
          prefixLength = 32;
        }];
        ipv6.routes = [{
          address = "fe80::1";
          prefixLength = 128;
        }];
      };

    };
  };

  services.udev.extraRules = ''
    ATTR{address}=="10:66:6a:ae:e3:d3", NAME="eth0"
  '';
}
