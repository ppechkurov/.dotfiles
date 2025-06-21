{
  programs.atuin = {
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      enter_accept = true;
      inline_height = 30;
      invert = true;
      keymap_mode = "vim-insert";
      keys = { scroll_exits = false; };
      max_preview_height = 10;
      show_preview = true;
      style = "full";
      update_check = false;
    };
  };
}
