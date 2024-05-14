{
  services = {
    mako = {
      enable = true;
      font = "JetBrainsMono Nerd Font 12";
      defaultTimeout = 5000;
      borderSize = 2;
      borderRadius = 5;
      backgroundColor = "#323232";
      borderColor = "#A89984";
      height = 200;
      progressColor = "over #313244";
      textColor = "#A89984";
      icons = true;
      actions = true;
      extraConfig = ''
        text-alignment=center
        [urgency=high]
        border-color=#fab387
      '';
    };
  };
}
