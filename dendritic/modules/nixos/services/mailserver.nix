{ inputs, self, ... }:
let
  domain = self.globals.dns.domain;
  email = self.globals.emails.gmail;
in
{
  flake.modules.nixos.mailserver = { config, ... }: {
    imports = [ inputs.mailserver.nixosModule ];

    age.secrets.mailserver-password.file = ./mailserver-password.age;

    security.acme.acceptTerms = true;
    security.acme.defaults.email = email;
    security.acme.certs."mail.${domain}".listenHTTP = "0.0.0.0:80";

    mailserver = {
      enable = true;
      fqdn = "mail.${domain}";
      domains = [ "${domain}" ];
      stateVersion = 3;
      openFirewall = true;
      enableSubmissionSsl = true; # open port 465

      # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
      accounts = {
        "petr.pechkurov@${domain}" = {
          hashedPasswordFile = config.age.secrets.mailserver-password.path;
        };
      };
      aliases = {
        "info@${domain}" = "petr.pechkurov@${domain}";
        "mattermost@${domain}" = "petr.pechkurov@${domain}";
        "no-reply@${domain}" = "petr.pechkurov@${domain}";
        "support@${domain}" = "petr.pechkurov@${domain}";
        "kirill.pechkurov@${domain}" = "petr.pechkurov@${domain}";
      };

      # Use Let's Encrypt certificates. Note that this needs to set up a stripped
      # down nginx and opens port 80.
      # certificateScheme = "acme-nginx";
      x509.useACMEHost = "mail.${domain}";
    };
  };
}
