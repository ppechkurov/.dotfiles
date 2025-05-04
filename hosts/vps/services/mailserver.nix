{ config, ... }: {
  age.secrets.mailserver-password.file = ./mailserver-password.age;

  mailserver = {
    enable = true;
    fqdn = "mail-pp.duckdns.org";
    domains = [ "mail-pp.duckdns.org" ];

    loginAccounts = {
      "petrp@mail-pp.duckdns.org" = {
        hashedPasswordFile = config.age.secrets.mailserver-password.path;
      };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";
  };
}
