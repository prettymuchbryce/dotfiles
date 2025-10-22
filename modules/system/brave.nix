{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:

let
  extSpecPath = "${flakeRoot}/.secrets/brave-extensions.nix";
  extSpecs = import extSpecPath; # [ { id = "..."; pin = true; } ... ]

  webstore = "https://clients2.google.com/service/update2/crx";

  mkExtensionXML =
    spec:
    let
      pinStr = if spec.pin then "force_pinned" else "default_unpinned";
    in
    ''
      <key>${spec.id}</key>
      <dict>
        <key>installation_mode</key><string>force_installed</string>
        <key>update_url</key><string>${webstore}</string>
        <key>toolbar_pin</key><string>${pinStr}</string>
      </dict>
    '';

  extensionEntries = lib.concatStringsSep "\n" (map mkExtensionXML extSpecs);

  macOSPolicyContent = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>BraveRewardsDisabled</key><true/>
      <key>BraveWalletDisabled</key><true/>
      <key>BraveVPNDisabled</key><true/>
      <key>BraveAIChatEnabled</key><false/>
      <key>BraveTalkDisabled</key><true/>
      <key>BraveNewsDisabled</key><true/>
      <key>BraveP3AEnabled</key><false/>
      <key>BraveWebDiscoveryEnabled</key><false/>
      <key>BraveStatsPingEnabled</key><false/>

      <!-- Disable built-in password manager -->
      <key>PasswordManagerEnabled</key><false/>

      <!-- Disable Chromium UMA (usage/crash metrics) -->
      <key>MetricsReportingEnabled</key><false/>

      <!-- Set Brave as default browser -->
      <key>DefaultBrowserSettingEnabled</key><true/>

      <!-- Manage extensions via ExtensionSettings -->
      <key>ExtensionSettings</key>
      <dict>
        <!-- Optional: block anything not explicitly listed -->
        <key>*</key>
        <dict>
          <key>installation_mode</key><string>blocked</string>
        </dict>

        <!-- Force-install + (optionally) pin -->
        ${extensionEntries}
      </dict>
    </dict>
    </plist>
  '';
in
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    # Install Brave to /Applications/Nix Apps/
    environment.systemPackages = [ pkgs.brave ];

    # Custom shorcuts
    system.defaults.CustomUserPreferences = {
      "com.brave.Browser" = {
        "NSUserKeyEquivalents"."Select Previous Tab" = "@j";
        "NSUserKeyEquivalents"."Select Next Tab" = "@;";
      };
    };

    # Write the managed policy at the system path Brave reads
    system.activationScripts.extraActivation.text = lib.mkAfter ''
      echo "Setting up Brave browser policies..." >&2
      set -euo pipefail

      install -d -m 755 -o root -g wheel "/Library/Managed Preferences"
      cat > "/Library/Managed Preferences/com.brave.Browser.plist" <<'EOF'
      ${macOSPolicyContent}
      EOF
      chown root:wheel "/Library/Managed Preferences/com.brave.Browser.plist"
      chmod 644 "/Library/Managed Preferences/com.brave.Browser.plist"

      # Refresh caches; Brave reads policies on launch
      # /usr/bin/killall cfprefsd >/dev/null 2>&1 || true
      # /usr/bin/osascript -e 'tell application "Brave Browser" to quit' >/dev/null 2>&1 || true
    '';
  };
}
