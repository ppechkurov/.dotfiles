{ pkgs, ... }:

let
  tofi-calc =
    pkgs.writeScriptBin "tofi-calc" (builtins.readFile ./scripts/tofi-calc.sh);
  tofi-emoji = pkgs.writeScriptBin "tofi-emoji"
    (builtins.readFile ./scripts/tofi-emoji.sh);
  tofi-launcher = pkgs.writeScriptBin "tofi-launcher"
    (builtins.readFile ./scripts/tofi-launcher.sh);
  tofi-powermenu = pkgs.writeScriptBin "tofi-powermenu"
    (builtins.readFile ./scripts/tofi-powermenu.sh);
in {
  config = {
    home.packages = with pkgs; [
      bc
      tofi
      tofi-calc
      tofi-emoji
      tofi-launcher
      tofi-powermenu
    ];

    xdg.configFile = {
      "tofi/one-line".source = ./config/one-line;
      "tofi/multi-line".source = ./config/multi-line;
    };
  };
}
