{ config, pkgs, lib, ... }:
with lib;
let cfg = config.local.mysql;
in {
  options.local.mysql.enable = mkEnableOption "mysql";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ mycli mysql84 ];

    home.file.".myclirc" = mkIf cfg.enable {
      enable = true;
      source = ./.myclirc;
    };
  };
}

