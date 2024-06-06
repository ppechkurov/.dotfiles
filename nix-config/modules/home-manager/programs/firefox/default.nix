{ pkgs, ... }: {
  programs.firefox.enable = true;
  programs.firefox = {
    profiles.petrp = {
      id = 0;
      name = "Petr P.";
      isDefault = true;

      #https://github.com/montchr/dotfield/blob/78de8ff316ccb2d34fd98cd9bfd3bfb5ad775b0e/home/profiles/firefox/search/default.nix
      search.force = true;
      search.default = "DuckDuckGo";
      search.engines = let
        engine = alias: template: icon: {
          definedAliases = [ "@${alias}" ];
          urls = [{ inherit template; }];
          inherit icon;
        };
      in {
        "Github Code" =
          engine "github" "https://github.com/search?q={searchTerms}&type=code"
          "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";

        "Npm" = engine "npm" "https://www.npmjs.com/search?q={searchTerms}" "";

        # "DuckDuckGo" =
        #   engine "duckduckgo" "https://duckduckgo.com/?q={searchTerms}";

        "NixOS packages" = engine "np"
          "https://search.nixos.org/packages?type=packages&query={searchTerms}"
          "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";

        "Nixfns" = engine "nixfns" "https://noogle.dev/q?term={searchTerms}"
          "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";

        "Bing".metaData.hidden = true;
        "Wikipedia".metaData.hidden = true;
        "Google".metaData.alias =
          "@g"; # builtin engines only support specifying one additional alias
      };
      # "NixOS packages" = {
      #   urls = [{
      #     template = "https://search.nixos.org/packages";
      #     params = [
      #       {
      #         name = "type";
      #         value = "packages";
      #       }
      #       {
      #         name = "query";
      #         value = "{searchTerms}";
      #       }
      #     ];
      #   }];
      #
      #   icon =
      #     "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      #   definedAliases = [ "@np" ];
      # };

      # "NixOS options" = {
      #   urls = [{
      #     template = "https://search.nixos.org/options";
      #     params = [
      #       {
      #         name = "type";
      #         value = "packages";
      #       }
      #       {
      #         name = "query";
      #         value = "{searchTerms}";
      #       }
      #     ];
      #   }];
      #
      #   icon =
      #     "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      #   definedAliases = [ "@no" ];
      # };

      # "NixOS Wiki" = {
      #   urls = [{
      #     template = "https://wiki.nixos.org/index.php?search={searchTerms}";
      #   }];
      #   icon =
      #     "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      #   definedAliases = [ "@nw" ];
      # };

      # "Home Manager" = {
      #   urls = [{
      #     template =
      #       "https://home-manager-options.extranix.com/?query={searchTerms}";
      #   }];
      #   icon =
      #     "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      #   definedAliases = [ "@hm" ];
      # };

      settings = {
        "devtools.toolbox.host" = "right";
        "browser.uidensity" = 1; # minimal ui
        "general.useragent.locale" = "en-US";
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

        #https://github.com/montchr/dotfield/blob/78de8ff316ccb2d34fd98cd9bfd3bfb5ad775b0e/home/profiles/firefox/search/default.nix
        search.force = true;
        search.default = "DuckDuckGo";

        # Prefer dark theme
        "layout.css.prefers-color-scheme.content-override" = 0;

        # "browser.uiCustomization.state" = ''
        #   {"placements":{"widget-overflow-fixed-list":[],"nav-bar":["back-button","forward-button","stop-reload-button","home-button","urlbar-container","downloads-button","library-button","ublock0_raymondhill_net-browser-action","_testpilot-containers-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","ublock0_raymondhill_net-browser-action","_testpilot-containers-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","widget-overflow-fixed-list"],"currentVersion":18,"newElementCount":4}'';

        # Auto-decline cookies
        "cookiebanners.service.mode" = 2;
        "cookiebanners.service.mode.privateBrowsing" = 2;
      };
    };

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      DisablePocket = true;
      SearchBar = "unified";

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

