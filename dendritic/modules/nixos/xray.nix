{
  flake.modules.nixos.xray = { lib, ... }:
    let port = 16823;
    in {
      services.xray.enable = true;

      networking.firewall.allowedTCPPorts = [ port ];
      services.xray.settings = {
        inbounds = [{
          inherit port;
          protocol = "vmess";
          settings = {
            clients = [{
              id = "b831381d-6324-4d53-ad4f-8cda48b30811";
              alterId = 64;
            }];
          };
        }];
        outbounds = [{
          protocol = "freedom";
          settings = { };
        }];
      };
    };
}
