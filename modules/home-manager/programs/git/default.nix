{ pkgs, ... }: {
  config = {
    programs.git = {
      enable = true;
      settings = {
        user.email = "petr.pechkurov@gmail.com";
        user.name = "Petr Pechkurov";
        init.defaultBranch = "main";
        credential.helper = "store";
        push.autosetupremote = true;
      };

      # 25.11 update
      # extraConfig = {
      # };
    };

    home.packages = [ pkgs.lazygit ];
  };
}
