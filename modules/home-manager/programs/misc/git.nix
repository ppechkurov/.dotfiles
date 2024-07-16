{ pkgs, ... }: {
  programs.git = {
    enable = true;

    userName = "enchanted-coder";
    userEmail = "danieltogey@pm.me";

    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "store";
      push.autoSetupRemote = true;
    };
  };

  home.packages = [ pkgs.gh pkgs.git-lfs ];
}
