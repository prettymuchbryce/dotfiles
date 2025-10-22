# NixOS Google Chrome with custom flags + policies
{
  config,
  lib,
  pkgs,
  ...
}:

let
  chrome = pkgs.google-chrome;

  # Wrapper with your runtime flags
  chromeWrapped = pkgs.writeShellApplication {
    name = "google-chrome-stable";
    runtimeInputs = [ chrome ];
    text = ''
      exec "${chrome}/bin/google-chrome-stable" \
        --ozone-platform=wayland \
        --enable-features=UseOzonePlatform,WebContentsForceDark \
        --force-dark-mode \
        --no-default-browser-check \
        --no-pings \
        "$@"
    '';
  };

  # One desktop file that overrides the upstream one (ULauncher reads this)
  chromeDesktop = pkgs.makeDesktopItem {
    name = "google-chrome"; # produces google-chrome.desktop
    desktopName = "Google Chrome";
    exec = "${chromeWrapped}/bin/google-chrome-stable %U";
    terminal = false;
    icon = "google-chrome";
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeTypes = [
      "text/html"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
    startupWMClass = "google-chrome"; # see notes below
    actions = {
      "new-window" = {
        name = "New Window";
        exec = "${chromeWrapped}/bin/google-chrome-stable";
      };
      "new-private-window" = {
        name = "New Incognito Window";
        exec = "${chromeWrapped}/bin/google-chrome-stable --incognito";
      };
    };
  };

in
{
  config = lib.mkIf pkgs.stdenv.isLinux {

    # Ensure the wrapper + desktop entry win over the package’s defaults
    environment.systemPackages = [
      (lib.hiPrio chromeWrapped)
      chrome
      (lib.hiPrio chromeDesktop)
    ];

    # Chrome/Chromium enterprise policies & first‑run preferences
    programs.chromium = {
      enable = true;

      # First-run preferences (user can change later)
      initialPrefs = {
        "RestoreOnStartup" = 1;
      };

      # Core enterprise policies (stable subset; add more as needed)
      extraOpts = {
        # Extensions — force‑install and pin; block everything else
        ExtensionSettings = {
          # uBlock Origin Lite (MV3) — see notes below on MV2 deprecation
          "ddkjiahejlhfcafbddmgiahcphecmpfh" = {
            installation_mode = "force_installed";
            update_url = "https://clients2.google.com/service/update2/crx";
            toolbar_pin = "force_pinned";
          };
          "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" = {
            # Privacy Badger
            installation_mode = "force_installed";
            update_url = "https://clients2.google.com/service/update2/crx";
            toolbar_pin = "force_pinned";
          };
          "eimadpbcbfnmbkopoojfekhnkhdbieeh" = {
            # Dark Reader
            installation_mode = "force_installed";
            update_url = "https://clients2.google.com/service/update2/crx";
            toolbar_pin = "force_pinned";
          };
          "oboonakemofpalcgghocfoadofidjkkk" = {
            # KeePassXC-Browser
            installation_mode = "force_installed";
            update_url = "https://clients2.google.com/service/update2/crx";
            toolbar_pin = "force_pinned";
          };
          "*" = {
            # Block everything else unless allowed above
            installation_mode = "blocked";
            blocked_install_message = "Extensions must be added in NixOS configuration!";
          };
        };

        # Per‑extension managed storage
        "3rdparty" = {
          "extensions" = {
            "ddkjiahejlhfcafbddmgiahcphecmpfh" = {
              disableFirstRunPage = true;
              defaultFiltering = "complete";
              strictBlockMode = true;
              rulesets = [
                "-*"
                "+default"
                "+ublock-badware"
                "+urlhaus-full"
                "+adguard-spyware-url"
                "+annoyances-cookies"
                "+annoyances-overlays"
                "+annoyances-social"
                "+annoyances-widgets"
                "+annoyances-others"
                "+deu-0"
              ];
            };
          };
        };

        # Privacy / security (keep to well‑supported, low‑breakage items)
        BlockThirdPartyCookies = true;
        DnsOverHttpsMode = "secure";
        DnsOverHttpsTemplates = "https://extended.dns.mullvad.net/dns-query";
        HttpsOnlyMode = "force_enabled";
        MetricsReportingEnabled = false;
        NetworkPredictionOptions = 2;
        SafeBrowsingProtectionLevel = 1; # standard safe browsing
        SearchSuggestEnabled = false;
        ShowFullUrlsInAddressBar = true;
        SitePerProcess = true;
        SyncDisabled = true;
        WebRtcIPHandling = "disable_non_proxied_udp";

        # GenAI slop removal
        AIModeSettings = 1;
        HelpMeWriteSettings = 2;
        GeminiSettings = 1;
        GenAILocalFoundationalModelSettings = 1;
      };
    };

    opensnitchRules = [
      {
        name = "Allow Chrome";
        process = "${chrome}/share/google/chrome/chrome";
      }
    ];
  };
}
