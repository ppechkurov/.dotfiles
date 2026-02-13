{ self, lib, ... }: {
  options.flake.adminUser = lib.mkOption {
    type = lib.types.str;
    default = "petrp";
  };

  config.flake.modules.nixos.data = { lib, ... }: {
    # options = {
    #   wgIpAddress = mkOption {
    #     type = types.str;
    #     default = "192.168.100.1";
    #   };
    # };

    config = { passthru.wgIpAddress = "192.168.100.1"; };
  };
}
