{
  programs.atuin.enable = true;
  programs.atuin = {
    enableZshIntegration = true;
    settings = {
      enter_accept = true;
      inline_height = 40;
      keymap_mode = "vim-normal";
      show_preview = true;
      update_check = false;
    };
  };
}

