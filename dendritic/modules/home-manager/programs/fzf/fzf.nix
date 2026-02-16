{
  flake.modules.homeManager.fzf = { pkgs, ... }: {
    home.packages = with pkgs; [ ripgrep ];

    programs.fzf.enable = true;
    programs.fzf = {
      defaultCommand = "rg --files --hidden --glob '!.git'";
      defaultOptions = [
        "--cycle"
        "--height=40%"
        "--layout=reverse"
        "--border=sharp"
        "--bind=tab:down,shift-tab:up"
      ];
      enableZshIntegration = true;
    };
  };
}
