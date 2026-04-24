{ self, ... }:
let email = self.globals.emails.gmail;
in {
  flake.modules.homeManager.git = { pkgs, lib, ... }: {
    home.packages = [ pkgs.lazygit ];

    programs.git.enable = true;
    programs.git.settings = {
      commit.gpgSign = true;
      init.defaultBranch = "main";
      push.autosetupremote = true;
      tag.gpgSign = true;
      user.email = lib.mkDefault email;
      user.name = "Petr Pechkurov";
    };
  };
}
