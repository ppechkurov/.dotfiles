{
  flake.nixosModules.petrp = { pkgs, ... }: {
    programs.zsh.enable = true;
    users.users.petrp = {
      description = "Petr Pechkurov";
      extraGroups =
        [ "networkmanager" "docker" "wheel" "disk" "power" "video" "forgejo" ];
      isNormalUser = true;
      shell = pkgs.zsh;
      # openssh.authorizedKeys.keys = publicKeys;
    };
  };
}
