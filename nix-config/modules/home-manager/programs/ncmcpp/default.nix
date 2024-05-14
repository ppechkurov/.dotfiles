{
  programs.ncmpcpp.enable = true;
  programs.ncmpcpp.bindings = [
    {
      key = "j";
      command = "scroll_down";
    }
    {
      key = "k";
      command = "scroll_up";
    }
  ];
}
