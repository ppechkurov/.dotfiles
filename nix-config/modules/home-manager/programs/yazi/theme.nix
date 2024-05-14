{
  filetype = {
    rules = [
      # Images
      {
        mime = "image/*";
        fg = "cyan";
      }
      # Media
      {
        mime = "{audio;video}/*";
        fg = "yellow";
      }
      # Archives
      {
        mime = "application/*zip";
        fg = "magenta";
      }
      {
        mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}";
        fg = "magenta";
      }
      # Documents
      {
        mime = "application/{pdf,doc,rtf,vnd.*}";
        fg = "lightyellow";
      }
      # Fallback
      # { name = "*"; fg = "white" };
      {
        name = "*/";
        fg = "blue";
      }
      # Executables
      {
        name = "*";
        is = "exec";
        fg = "lightgreen";
        italic = true;
      }
      # Symlinks
      {
        name = "*";
        is = "link";
        fg = "green";
        dim = true;
      }
      # Orphaned symlinks
      {
        name = "*";
        is = "orphan";
        fg = "lightred";
        crossed = true;
      }
    ];
  };
}
