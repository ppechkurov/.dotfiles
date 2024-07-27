let
  modules = {
    cava = "cava";
    clipboard = "custom/clipboard";
    clock = "clock";
    cpu = "cpu";
    disk = "disk";
    idle = "custom/swayidle";
    language = "hyprland/language";
    memory = "memory";
    mode = "hyprland/submap";
    network = "network";
    os-icon = "custom/os-icon";
    pipe = "custom/pipe";
    power = "custom/power";
    sound = "pulseaudio";
    workspaces = "hyprland/workspaces";
  };
  bars = {
    small = "4e635b"; # cyan2
    high = "a31d17"; # red2
  };
in {
  mainBar = with modules; {
    layer = "bottom";
    position = "top";

    modules-left = [
      "${os-icon}"
      "${pipe}"
      "${workspaces}"
      "${pipe}"
      "${disk}"
      "${pipe}"
      "tray"
      # "${pipe}"
      # "${cava}"
    ];

    cava = {
      framerate = 30;
      autosens = 1;
      bars = 18;
      lower_cutoff_freq = 50;
      higher_cutoff_freq = 10000;
      method = "pipewire";
      source = "auto";
      stereo = true;
      reverse = false;
      bar_delimiter = 0;
      monstercat = false;
      waves = false;
      input_delay = 1;
      format-icons = with bars; [
        "<span foreground='#${small}'>▁</span>"
        "<span foreground='#${small}'>▂</span>"
        "<span foreground='#${small}'>▃</span>"
        "<span foreground='#${small}'>▄</span>"
        "<span foreground='#${small}'>▅</span>"
        "<span foreground='#${small}'>▆</span>"
        "<span foreground='#${small}'>▇</span>"
        "<span foreground='#${small}'>█</span>"
      ];
    };

    modules-center = [ "${mode}" "${clock}" ];

    modules-right = [
      "${network}"
      "${pipe}"
      "${cpu}"
      "${pipe}"
      "${memory}"
      "${pipe}"
      "${clipboard}"
      "${sound}"
      "${sound}#mic"
      "${idle}"
      "${pipe}"
      "${language}"
    ];

    "${os-icon}" = {
      format = "";
      interval = "once";
      tooltip = false;
      #TODO: update these scripts
      on-click = "~/.config/sway/scripts/settings";
      on-click-right = "~/.config/mako/scripts/mako_sysnfo";
    };

    "${pipe}" = {
      interval = "once";
      format = "|";
      tooltip = false;
    };

    "${workspaces}" = {
      disable-scroll = true;
      format = "{icon} ";
      sort-by-number = true;
      # all-outputs = true;
      format-icons = {
        "1" = "";
        "2" = "";
        "3" = "";
        "4" = "";
        "5" = "󰒱";
        "6" = "";
        "7" = "";
        "8" = "";
        "9" = "";
        "10" = "󰒯";
      };
      "persistent-workspaces" = { "*" = 5; };
      # "persistent-workspaces" = {
      #   # DP-4 = [ "1" "2" "3" "4" "5" ];
      #   # DVI-D-1 = [ "6" "7" "8" "9" "10" ];
      #   # "1" = [ "DP-4" ];
      #   # "2" = [ "DP-4" ];
      #   # "3" = [ "DP-4" ];
      #   # "4" = [ "DP-4" ];
      #   # "5" = [ "DP-4" ];
      #   # "6" = [ "DVI-D-1" ];
      #   # "7" = [ "DVI-D-1" ];
      #   # "8" = [ "DVI-D-1" ];
      #   # "9" = [ "DVI-D-1" ];
      #   # "10" = [ "DVI-D-1" ];
      # };
    };

    "${disk}" = { format = "󰋊 {free}"; };

    "${clock}" = {
      interval = 1;
      format = "{:%a %d %b %H:%M:%S}";
      tooltip = false;
      #TODO: update this script
      on-click-right = "~/.config/mako/scripts/mako_calendar";
    };

    "${network}" = {
      # interface = "wlp2*"; # (Optional) To force the use of this interface
      format-wifi = "({signalStrength}%) ";
      format-ethernet = "  {bandwidthUpBytes} |   {bandwidthDownBytes} 󰈀 ";
      interval = 2;
      tooltip-format = "󱘖 {ipaddr}";
      format-linked = "{ifname} (No IP) ?";
      format-disconnected = "x";
      #TODO: update this script
      on-click = "~/.local/bin/dmenu_network";
    };

    "${cpu}" = {
      format = "  {usage}%";
      tooltip = false;
      interval = 2;
      format-alt = "  {avg_frequency} GHz";
      on-click = "$TERMINAL -a float_htop -e htop";
    };

    "${memory}" = {
      format = "  {used:0.1f}GB";
      interval = 2;
      tooltip = false;
      on-click = "$TERMINAL -a float_htop -e htop";
    };

    tray = {
      icon-size = 20;
      spacing = 8;
    };

    "${sound}" = {
      format = "{icon} <b>{volume}</b>%";
      format-bluetooth = " ᛒ <b>{volume}</b>";
      format-bluetooth-muted = " ";
      format-muted = " {format_source}";
      format-icons = { default = [ "" "" "" ]; };
      scroll-step = 5;
      on-click = "pavucontrol";
    };

    "${sound}#mic" = {
      format = "{format_source}";
      format-source = "";
      format-source-muted = "  ";
      format-bluetooth = "{format_source}";
      on-click = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
    };

    "${idle}" = {
      interval = "once";
      format = "{}";
      exec = "~/.config/sway/scripts/swayidle-toggle status";
      signal = 8;
      on-click = "~/.config/sway/scripts/swayidle-toggle toggle";
    };

    "${language}" = {
      format = "{shortDescription}";
      on-click = "swaymsg input type:keyboard xkb_switch_layout next";
    };

    "${power}" = {
      interval = "once";
      format = "";
      tooltip = false;
      # on-click = "~/.config/sway/scripts/power_thing";
      on-click = "tofi-powermenu";
      on-click-right = "$TERMINAL -a floatterm -e ~/.local/bin/popupgrade";
    };
  };
}
