{
  flake.modules.nixos.pam = {
    security.pam.services.greetd.oathAuth = true;
    age.secrets."users.oath" = {
      file = ./users.oath.age;
      path = "/etc/users.oath";
      owner = "root";
      group = "root";
      mode = "600";
    };
    # security.pam.services.greetd = {
    #   oathAuth = true;
    #   rules.auth.oath.control = "sufficient";
    #   rules.auth.oath.order = 11100;
    #
    #   # Skip oath for everyone except petrp
    #   rules.auth.skipOathForOthers = {
    #     enable = true;
    #     control = "[success=1 default=ignore]";
    #     modulePath = "pam_succeed_if.so";
    #     order = 11099; # just before oath
    #     args = [ "user" "!=" "petrp" ];
    #   };
    # };
  };
}
