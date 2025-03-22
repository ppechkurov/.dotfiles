{ pkgs, pkgs-unstable, ... }: {
  programs.floorp.enable = true;
  programs.floorp = {
    package = pkgs-unstable.floorp;
    profiles.petrp = {
      id = 0;
      name = "Petr P";
      isDefault = true;

      containersForce = true;
      containers = let cont = icon: color: id: { inherit icon color id; };
      in {
        Work = cont "briefcase" "orange" 1;
        Personal = cont "fingerprint" "blue" 2;
      };

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

        "NixOS packages" = engine "np"
          "https://search.nixos.org/packages?type=packages&query={searchTerms}"
          "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";

        "NixOS options" =
          engine "no" "https://search.nixos.org/options?query={searchTerms}"
          "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";

        "Home Manager - Option Search" = engine "hm"
          "https://home-manager-options.extranix.com/?query={searchTerms}"
          "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";

        "Bing".metaData.hidden = true;
        "Wikipedia".metaData.hidden = true;
        "Startpage".metaData.hidden = true;
        "You.com".metaData.hidden = true;
        "Google".metaData.alias =
          "@g"; # builtin engines only support specifying one additional alias
      };

      settings = {
        "devtools.toolbox.host" = "right";
        "browser.uidensity" = 1; # minimal ui

        # locale
        "browser.search.region" = "US";
        "browser.search.isUS" = true;
        "general.useragent.locale" = "en-US";
        "distribution.searchplugins.defaultLocale" = "en-US";

        "browser.startup.page" = 3;
        "browser.newtabpage.pinned" = [
          {
            "label" = "Monkeytype";
            "url" = "https://monkeytype.com";
          }
          {
            "label" = "GitHub";
            "url" = "https://github.com";
          }
          {
            "label" = "YouTube";
            "url" = "https://youtube.com";
          }
        ];

        # Prefer dark theme
        "layout.css.prefers-color-scheme.content-override" = 0;

        # Auto-decline cookies
        "cookiebanners.service.mode" = 2;
        "cookiebanners.service.mode.privateBrowsing" = 2;

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
      OfferToSaveLoginsDefault = false;
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

        # this is broken on 24.11 atm
        # github-refined
        "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}/latest.xpi";
          installation_mode = "force_installed";
        };

        # you-com
        "{82b57c0f-7165-4ce2-afe0-f03c11d1fc51}" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/{82b57c0f-7165-4ce2-afe0-f03c11d1fc51}/latest.xpi";
          installation_mode = "blocked";
        };
      };

      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };

      FirefoxHome = {
        "Search" = true;
        "TopSites" = true;
        "SponsoredTopSites" = false;
        "Highlights" = false;
        "Pocket" = false;
        "SponsoredPocket" = false;
        "Snippets" = false;
        "Locked" = true;
      };

      Extensions = {
        Uninstall = [
          "google@search.mozilla.org"
          "bing@search.mozilla.org"
          "amazondotcom@search.mozilla.org"
          "ebay@search.mozilla.org"
          "twitter@search.mozilla.org"
          "youtube@search.mozilla.org"
          "yahoo@search.mozilla.org"
          "startpage-private-search@search.mozilla.org"
          "you-com@search.mozilla.org"
        ];
      };
    };
  };
}

