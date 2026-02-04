{
  flake.nixosModules.data = let v = builtins.trace "shit";
  in { lib, ... }:
  with lib; {
    # options = {
    #   wgIpAddress = mkOption {
    #     type = types.str;
    #     default = "192.168.100.1";
    #   };
    # };
    passthru.wgIpAddress = "192.168.100.1";
  };
}
