{ self, ... }:
let user = "petrp";
in {
  flake.modules.nixos.${user} = { pkgs, lib, ... }: {
    programs.zsh.enable = true;
    users.users.${user} = with lib; {
      description = mkDefault "Petr Pechkurov";
      extraGroups = mkDefault [ "networkmanager" "wheel" "disk" "power" ];
      isNormalUser = mkDefault true;
      shell = pkgs.zsh;
      # openssh.authorizedKeys.keys = publicKeys;
    };
  };
}
