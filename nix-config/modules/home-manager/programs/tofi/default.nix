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
  tofi-pass =
    pkgs.writeScriptBin "tofi-pass" (builtins.readFile ./scripts/tofi-pass.sh);
  tofi-ssh =
    pkgs.writeScriptBin "tofi-ssh" (builtins.readFile ./scripts/tofi-ssh.sh);
  tofi-clip =
    pkgs.writeScriptBin "tofi-clip" (builtins.readFile ./scripts/tofi-clip.sh);
in {
  config = {
    home.packages = with pkgs; [
      bc
      tofi
      tofi-calc
      tofi-emoji
      tofi-launcher
      tofi-pass
      tofi-powermenu
      tofi-ssh
      tofi-clip
    ];

    xdg.configFile = {
      "tofi/one-line".source = ./config/one-line;
      "tofi/multi-line".source = ./config/multi-line;
      "tofi/pass".source = ./config/pass;
    };

    xdg.configFile = { "tessen/config".source = ./tessen/config; };
  };
}
