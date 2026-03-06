{ self, ... }:
let user = "petrp";
in {
  flake.modules.nixos.mini = { pkgs, pkgs-unstable, ... }: {
    users.users.${user} = {
      extraGroups = [ "transmission" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPhEZUfUL6KX4uWMR7G7b9oxPBaaucCVFrU9ULA9+c+b petrp@webdock" # to mount sshfs
      ];
    };

    home-manager.users.${user} = {
      imports = with self.modules.homeManager; [
        cli
        # mini # mini it's a hostname in this case
        nvim
        xdg
      ];

      # provides pkgs-unstable param in hm modules
      _module.args = { inherit pkgs-unstable; };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      home.stateVersion = "24.05";
    };
  };
}
