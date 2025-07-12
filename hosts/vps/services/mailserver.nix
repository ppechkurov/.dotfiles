{ config, lib, ... }:
let domain = "slonverse.xyz";
in {
  age.secrets.mailserver-password.file = ./mailserver-password.age;

  mailserver = {
    enable = true;
    fqdn = "mail.${domain}";
    domains = [ "${domain}" ];
    stateVersion = 3;

    loginAccounts = {
      "petr.pechkurov@${domain}" = {
        hashedPasswordFile = config.age.secrets.mailserver-password.path;
      };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";
  };
}
