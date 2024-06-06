let
  scratch = "class:scratch";
  music = "class:music";
in [
  "float, ${scratch}"
  "size 80% 80%, ${scratch}"
  "center, floating:1, ${scratch}"
  "noblur, ${scratch}"

  "float, ${music}"
  "size 80% 80%, ${music}"
  "center, floating:1, ${music}"

  "workspace 4 silent, class:org.telegram.desktop"
  "workspace 7, class:firefox"
]

