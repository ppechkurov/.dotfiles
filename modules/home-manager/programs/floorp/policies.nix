{ withAllSearchEngines ? false, lib, writeText, ... }:

# See: https://mozilla.github.io/policy-templates/
writeText "policies.json" (builtins.toJSON {
  policies = {
    OverrideFirstRunPage = "";
    OverridePostUpdatePage = "";
    DisableAppUpdate = true;
    DisableSystemAddonUpdate = true;
    DisableFirefoxStudies = true;
    DisableTelemetry = true;
    DisableFeedbackCommands = true;
    SearchBar = "unified";
    SearchSuggestEnabled = false;
    SearchEngines = {
      Add = [{
        Alias = "@sx";
        Name = "SearXNG";
        Description = "SearXNG — a privacy-respecting, open metasearch engine";
        IconURL =
          "https://search.sapti.me/static/themes/simple/img/favicon.png";
        URLTemplate = "https://search.sapti.me/search?q={searchTerms}";
      }] ++ lib.optionals withAllSearchEngines [
        {
          Alias = "@np";
          Name = "NixOS Packages";
          Description = "Search NixOS packages by name or description.";
          IconURL = "https://nixos.org/favicon.png";
          URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
        }
        {
          Alias = "@no";
          Name = "NixOS Options";
          Description = "Search NixOS options by name or description.";
          IconURL = "https://nixos.org/favicon.png";
          URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
        }
        {
          Alias = "@ng";
          Name = "Noogle";
          Description = "Search for nix functions by name.";
          IconURL = "https://noogle.dev/favicon.png";
          URLTemplate = "https://noogle.dev/q?term={searchTerms}";
        }
        {
          Alias = "@hg";
          Name = "Hoogle";
          Description = ''
              Hoogle is a Haskell API search engine, which allows you to
            search many standard Haskell libraries by either function name,
            or by approximate type signature.'';
          URLTemplate = "https://hoogle.haskell.org/?hoogle={searchTerms}";
          IconURL = "https://hoogle.haskell.org/favicon64.png";
        }
      ];
      Default = "SearXNG";
      Remove =
        [ "Google" "Bing" "Amazon.com" "eBay" "Twitter" "YouTube" "Yahoo" ];
    };
    FirefoxSuggest = {
      WebSuggestions = false;
      SponsoredSuggestions = false;
      ImproveSuggest = false;
      Locked = true;
    };
    Preferences = {
      "layout.spellcheckDefault" = {
        Value = 0;
        Status = "locked";
      };
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
      ];
    };
    Containers.Default =
      let cont = name: icon: color: { inherit name icon color; };
      in [
        (cont "per" "fingerprint" "blue")
        (cont "wor" "briefcase" "orange")
        (cont "com" "tree" "green")
        (cont "fin" "dollar" "yellow")
        (cont "sea" "circle" "purple")
      ];
  };
})

