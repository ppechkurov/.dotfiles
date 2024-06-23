{ pkgs, ... }:
let ouath2 = pkgs.writeScriptBin "music" (builtins.readFile ./scripts/music.sh);
in {
  home.packages = [ pkgs.meli pkgs.python3 ouath2 ];
  xdg.configFile.meli = {
    enable = true;
    source = ./config.toml;
    target = "meli/config.toml";
  };
}
