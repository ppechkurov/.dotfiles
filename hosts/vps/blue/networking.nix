{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers =
      [ "1.1.1.1" "8.8.8.8" "2606:4700:47008.8.8.8111" "2001:4860:4860::8888" ];
    defaultGateway = "194.61.121.1";
    defaultGateway6 = {
      address = "2a10:1fc0:8::1";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [{
          address = "194.61.121.124";
          prefixLength = 25;
        }];
        ipv6.addresses = [
          {
            address = "2a10:1fc0:8::53e4:2e94";
            prefixLength = 48;
          }
          {
            address = "2a10:1fc0:8::f6d9:989f";
            prefixLength = 48;
          }
          {
            address = "2a10:1fc0:8::359f:a4b9";
            prefixLength = 48;
          }
          {
            address = "2a10:1fc0:8::19f1:d56f";
            prefixLength = 48;
          }
        ];
        ipv4.routes = [{
          address = "194.61.121.1";
          prefixLength = 32;
        }];
        ipv6.routes = [{
          address = "2a10:1fc0:8::1";
          prefixLength = 128;
        }];
      };

    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="00:16:3c:9d:14:16", NAME="eth0"
  '';
}
