scratch_term_cmd: [
  # left
  "1, monitor:DVI-D-1, default:true"
  "2, monitor:DVI-D-1"
  "3, monitor:DVI-D-1"
  "4, monitor:DVI-D-1"
  "5, monitor:DVI-D-1"

  # right. requires duplicate for some reason. check `hyprctl monitors all`
  "6, monitor:DP-4, default:true"
  "7, monitor:DP-4"
  "8, monitor:DP-4"
  "9, monitor:DP-4"
  "10, monitor:DP-4"
  "6, monitor:DP-1, default:true"
  "7, monitor:DP-1"
  "8, monitor:DP-1"
  "9, monitor:DP-1"
  "10, monitor:DP-1"

  "special:scratch, on-created-empty:[stayfocused] ${scratch_term_cmd}"
  "special:music, on-created-empty:[stayfocused] music"
]
