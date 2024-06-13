{ config, ... }: {
  programs.hyprlock.enable = true;

  programs.hyprlock.settings = {
    general = {
      disable_loading_bar = true;
      grace = 300;
      hide_cursor = true;
      no_fade_in = false;
    };

    background = {
      monitor = "";
      path =
        "${config.home.homeDirectory}/.config/hypr/hackerman-wallpapers.jpg";
      blur_passes = 3;
      blur_size = 4;
      noise = 1.17e-2;
      contrast = 0.8916;
      brightness = 0.8172;
      vibrancy = 0.1696;
      vibrancy_darkness = 0.0;
    };

    label = [{
      text = ''cmd[update:200:1] echo "<b><big> $TIME </big></b>"'';
      font_size = 64;
      position = "0, 16";
      halign = "center";
      valign = "center";
    }];

    input-field = [{
      size = "200, 50";
      position = "0, -80";
      monitor = "";
      dots_center = true;
      fade_on_empty = false;
      font_color = "rgb(202, 211, 245)";
      inner_color = "rgb(91, 96, 120)";
      outer_color = "rgb(24, 25, 38)";
      outline_thickness = 5;
      placeholder_text = "Password...";
      shadow_passes = 2;
    }];
  };
}

