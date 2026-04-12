{
  flake.modules.nixos.pam = { pkgs, lib, config, ... }: {
    environment.systemPackages = [ pkgs.pamtester pkgs.oath-toolkit ];

    age.secrets."users.oath" = {
      file = ./users.oath.age;
      path = "/etc/users.oath";
      group = "root";
      mode = "600";
    };

    security.pam.services.greetd = {
      unixAuth = true; # Password authentication
      oathAuth = true; # TOTP authentication
    };
  };
}
