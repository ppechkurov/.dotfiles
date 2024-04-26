{ pkgs, ... }: {
  config = {
    programs.git = {
      enable = true;
      userEmail = "petr.pechkurov@gmail.com";
      userName = "Petr Pechkurov";

      extraConfig = {
        init.defaultBranch = "main";
        credential.helper = "store";
      };
    };

    home.packages = [ pkgs.lazygit ];
  };
}
