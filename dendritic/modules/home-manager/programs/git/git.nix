{ self, ... }:
let email = self.globals.emails.gmail;
in {
  flake.modules.homeManager.git = { pkgs, lib, ... }: {
    home.packages = [ pkgs.lazygit ];

    programs.git.enable = true;
    programs.git.settings = {
      user.email = lib.mkDefault email;
      user.name = "Petr Pechkurov";
      init.defaultBranch = "main";
      credential.helper = "store";
      push.autosetupremote = true;
      commit.gpgSign = true;
      tag.gpgSign = true;
    };
  };
}
