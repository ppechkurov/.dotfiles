{
  flake.modules.homeManager.xdg = {
    xdg.enable = true;

    xdg = {
      mime.enable = true;
      mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = [ "firefox.desktop" ];
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/about" = "firefox.desktop";
          "x-scheme-handler/unknown" = "firefox.desktop";
          "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
        };
      };
      userDirs = {
        enable = true;
        createDirectories = true;
        setSessionVariables = true;
      };
    };
  };
}
