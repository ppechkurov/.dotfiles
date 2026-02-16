{
  flake.modules.homeManager.mycli = { pkgs, config, ... }: {
    home.packages = with pkgs; [ mycli ];

    home.file.".myclirc" = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink ./.myclirc;
    };
  };
}
