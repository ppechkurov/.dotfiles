{ self, ... }:
let user = "petrp";
in {
  flake.modules.nixos.${user} = { pkgs, lib, ... }: {
    programs.zsh.enable = true;
    users.users.${user} = with lib; {
      description = mkDefault "Petr Pechkurov";
      extraGroups = [ "docker" "networkmanager" "wheel" "disk" "power" ];
      isNormalUser = mkDefault true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = self.globals.publicKeys.users.${user};
    };

    programs.ssh.extraConfig = # bash
      ''
        Host github.com
          IdentitiesOnly yes
          User git
          Hostname github.com
          PreferredAuthentications publickey
          IdentityFile /home/${user}/.ssh/id_ed25519
      '';
  };
}
