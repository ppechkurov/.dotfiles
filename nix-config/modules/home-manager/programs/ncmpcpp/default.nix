{ pkgs, ... }: {
  # https://github.com/NotAShelf/nyx/blob/b5758f4da4bcc27e967fa7dfcb9c7f7aa21a05f4/homes/notashelf/programs/media/ncmpcpp/settings.nix
  programs.ncmpcpp.enable = true;
  # programs.ncmpcpp.package =
  #   pkgs.ncmpcpp.override { visualizerSupport = true; };

  programs.ncmpcpp = {
    bindings = import ./bindings.nix;
    settings = {
      user_interface = "alternative";
      alternative_header_first_line_format =
        "$(11)█▓▒░ $b$(13)%a$(end)$/b ░▒▓█$(end)";
      alternative_header_second_line_format = "$(4)%t$(end)";
      alternative_ui_separator_color = 11;

      # visualizer
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "Visualiser";
      visualizer_in_stereo = "yes";
      visualizer_spectrum_smooth_look = "yes";
      # visualizer_type = "wave";

      # startup screen
      # startup_screen = "visualizer";
      # startup_slave_screen = "playlist";
      # startup_slave_screen_focus = "yes";

      ignore_leading_the = true;
      message_delay_time = 1;
      playlist_disable_highlight_delay = 5;
      execute_on_song_change = ''
        ${pkgs.libnotify}/bin/notify-send "Now playing:" "$(${pkgs.ncmpcpp}/bin/ncmpcpp --current-song '{{{{%a - }%t}}|{%f}}')"'';
      autocenter_mode = "yes";
      centered_cursor = "yes";
      allow_for_physical_item_deletion = "yes";
      lines_scrolled = "0";

      # appearance
      colors_enabled = "yes";
      volume_color = "white";

      # window
      song_window_title_format = "Music";
      # statusbar_visibility = "no";
      # header_visibility = "no";
      # titles_visibility = "no";

      # progress bar
      progressbar_look = "░▒▓";
      progressbar_color = "black";
      progressbar_elapsed_color = "blue";

      # song list
      song_status_format = "$7%t";
      song_list_format = "$(008)%t$R  $(247)%a$R$5  %l$8";
      # song_columns_list_format = "(53)[blue]{tr} (45)[blue]{a}";

      # current_item_prefix = "$b$2| ";
      # current_item_suffix = "$/b$5";

      now_playing_prefix = "$b$5|";
      now_playing_suffix = "$/b$5";

      song_library_format = "{{%a - %t} (%b)}|{%f}";

      # colors
      main_window_color = "blue";

      current_item_inactive_column_prefix = "$b$5|";
      current_item_inactive_column_suffix = "$/b$5";

      color1 = "white";
      color2 = "blue";
    };
  };
}
