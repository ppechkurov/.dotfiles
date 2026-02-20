{
  flake.modules.homeManager.yazi = {
    programs.yazi.theme.filetype = {
      rules = [
        # Image
        {
          mime = "image/*";
          fg = "yellow";
        }
        # Video
        {
          mime = "{audio,video}/*";
          fg = "magenta";
        }
        # Empty file
        {
          mime = "inode/empty";
          fg = "cyan";
        }
        # Orphan symbolic links
        {
          url = "*";
          is = "orphan";
          fg = "red";
        }
        # Fallback
        {
          url = "*/";
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
  };
}
