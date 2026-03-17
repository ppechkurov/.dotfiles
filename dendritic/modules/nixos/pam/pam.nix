{
  flake.modules.nixos.pam = { pkgs, lib, config, ... }: {
    environment.systemPackages = [ pkgs.pamtester ];

    # generate a secret with `openssl rand -hex 20`
    # in a file: HOTP/T30/6 <user> - <secret>
    age.secrets."users.oath" = {
      file = ./users.oath.age;
      path = "/etc/users.oath";
      group = "root";
      mode = "600";
    };

    security.pam.services.greetd.unixAuth = true;
    security.pam.services.greetd.oathAuth = true;
  };
}
