{ ... }: {
  programs.firefox.enable = true;
  programs.firefox = {
    profiles.petrp = {
      id = 0;
      name = "Petr P.";
      isDefault = true;
      settings = {
        "browser.startup.page" = 3;
        "browser.newtabpage.pinned" = [
          {
            "label" = "GitHub";
            "url" = "https://github.com";
          }
          {
            "label" = "YouTube";
            "url" = "https://youtube.com";
          }
          {
            "label" = "YT Music";
            "url" = "https://music.youtube.com";
          }
          {
            "label" = "Monkeytype";
            "url" = "https://monkeytype.com";
          }
        ];

        # Auto-decline cookies
        "cookiebanners.service.mode" = 2;
        "cookiebanners.service.mode.privateBrowsing" = 2;
      };
    };
    policies = {
      DisableTelemetry = true;
      # ---- EXTENSIONS ----
      # Check about:support for extension/add-on ID strings.
      # Valid strings for installation_mode are "allowed", "blocked",
      # "force_installed" and "normal_installed".
      ExtensionSettings = {
        "*".installation_mode =
          "allowed"; # blocks all addons except the ones specified below
        # uBlock Origin:
        "uBlock0@raymondhill.net" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };

        # Surfingkeys
        "{a8332c60-5b6d-41ee-bfc8-e9bb331d34ad}" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/{a8332c60-5b6d-41ee-bfc8-e9bb331d34ad}/latest.xpi";
          installation_mode = "force_installed";
        };

        # github-refined
        "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
}

