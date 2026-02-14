{ self, ... }:
let email = self.globals.emails.gmail;
in {
  flake.modules.homeManager.git = { pkgs, lib, ... }: {
    programs.git.enable = true;
    home.packages = [ pkgs.lazygit ];

    programs.git.settings = {
      user.email = email;
      user.name = "Petr Pechkurov";
      init.defaultBranch = "main";
      credential.helper = "store";
      push.autosetupremote = true;
    };
  };
}
