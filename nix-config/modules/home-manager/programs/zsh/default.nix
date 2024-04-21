{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";
    antidote = {
      enable = true;
      plugins = [ "romkatv/powerlevel10k" ];
    };
    oh-my-zsh = {
      enable = true;
    };
    initExtra = ''
    source ~/.p10k.zsh
    '';
  };

  home.file.".p10k.zsh" = {
    enable = true;
    source = ./.p10k.zsh;
  };
}
