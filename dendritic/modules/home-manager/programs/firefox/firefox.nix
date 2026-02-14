{
  flake.modules.homeManager.firefox = { pkgs, lib, ... }: {
    programs.firefox.enable = true;

    programs.firefox = {
      # not all of the bellow works. check home-manager.librewolf options.
      # package = pkgs.librewolf;
      profiles.petrp = {
        id = 0;
        name = "Petr P.";
        isDefault = true;

        #https://github.com/montchr/dotfield/blob/78de8ff316ccb2d34fd98cd9bfd3bfb5ad775b0e/home/profiles/firefox/search/default.nix
        search.force = true;
        search.default = "ddg";
        search.engines = let
          engine = alias: template: icon: {
            definedAliases = [ "@${alias}" ];
            urls = [{ inherit template; }];
            inherit icon;
          };
        in {
          "Github Code" = engine "github"
            "https://github.com/search?q={searchTerms}&type=code"
            "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";

          "NixOS packages" = engine "np"
            "https://search.nixos.org/packages?type=packages&query={searchTerms}"
            "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";

          "NixOS options" =
            engine "no" "https://search.nixos.org/options?query={searchTerms}"
            "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";

          "Home Manager - Option Search" = engine "hm"
            "https://home-manager-options.extranix.com/?query={searchTerms}"
            "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";

          "bing".metaData.hidden = true;
          "wikipedia".metaData.hidden = true;
          "google".metaData.alias =
            "@g"; # builtin engines only support specifying one additional alias
        };

        containers = {
          personal = {
            id = 1;
            name = "Personal";
            color = "blue";
            icon = "fingerprint";
          };
          work = {
            id = 2;
            name = "Work";
            color = "orange";
            icon = "briefcase";
          };
        };

        settings = {
          "devtools.toolbox.host" = "right";
          "general.useragent.locale" = "en-US";

          "accessibility.force_disabled" = true;
          "browser.sessionstore.interval" = 60000; # 1 min
          "browser.uidensity" = 1; # minimal ui
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
              "label" = "Monkeytype";
              "url" = "https://monkeytype.com";
            }
          ];

          # Prefer dark theme
          "layout.css.prefers-color-scheme.content-override" = 0;

          # Auto-decline cookies
          "cookiebanners.service.mode" = 2;
          "cookiebanners.service.mode.privateBrowsing" = 2;

          "browser.urlbar.suggest.topsites" = false;
          # https://github.com/gingkapls/dotnix/blob/f2b912b992708bc05e478c78725eb18c1038f790/hm/programs/firefox/default.nix#L4
          # turn of google safebrowsing (it literally sends a sha sum of everything you download to google)
          "browser.safebrowsing.downloads.remote.block_dangerous" = false;
          "browser.safebrowsing.downloads.remote.block_dangerous_host" = false;
          "browser.safebrowsing.downloads.remote.block_potentially_unwanted" =
            false;
          "browser.safebrowsing.downloads.remote.block_uncommon" = false;
          "browser.safebrowsing.downloads.remote.url" = false;
          "browser.safebrowsing.downloads.remote.enabled" = false;
          "browser.safebrowsing.downloads.enabled" = false;

          # telemetry
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;

          # https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
          "browser.topsites.contile.enabled" = false;
          "browser.search.suggest.enabled" = false;
          "browser.search.suggest.enabled.private" = false;
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.showSearchSuggestionsFirst" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" =
            false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" =
            false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" =
            false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" =
            false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.system.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        };
      };

      # https://github.com/adtya/configuration.nix/blob/cb825841cc442356386d12789edc7ba7abdd5365/home/programs/firefox.nix
      policies = {
        DisableAppUpdate = true;
        DisableFirefoxAccounts = true;
        DisableFirefoxStudies = true;
        DisableFormHistory = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisplayBookmarksToolbar = "newtab";
        DontCheckDefaultBrowser = true;

        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = true;
        };

        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          EmailTracking = true;
          Fingerprinting = true;
        };
        NoDefaultBookmarks = true;

        SearchBar = "unified";
        OfferToSaveLogins = false;
        RequestedLocales = [ "en-US" ];

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
  };
}
