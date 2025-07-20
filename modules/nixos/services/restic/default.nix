{ pkgs, config, ... }:
let
  owner = "restic";
  group = config.users.users.${owner}.group;
in {
  age.secrets.restic-password-file = {
    file = ./restic-password-file.age;
    inherit owner group;
  };

  # see [link](https://wiki.nixos.org/wiki/Restic)
  users.users.restic = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMrby7Og0kSdysnQKj54rCzJirVZqLFD8MYMV6pZRA2K restic@webdock"
    ];
  };

  environment.systemPackages = [ pkgs.restic ];
  security.wrappers.restic = {
    inherit owner group;
    source = "${pkgs.restic.out}/bin/restic";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };
}
