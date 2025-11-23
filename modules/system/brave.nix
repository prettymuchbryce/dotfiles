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

  dnsServers = import "${flakeRoot}/.secrets/brave-secure-dns.nix";

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

      <!-- Disable update checks and prompts -->
      <key>UpdatesSuppressed</key><true/>

      <!-- Set Brave as default browser -->
      <key>DefaultBrowserSettingEnabled</key><true/>

      <!-- Enable secure DNS with Mullvad -->
      <key>DnsOverHttpsMode</key><string>secure</string>
      <key>DnsOverHttpsTemplates</key><string>${dnsServers}</string>

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

      target="/Library/Managed Preferences/com.brave.Browser.plist"
      dir="$(dirname "$target")"
      install -d -m 755 -o root -g wheel "$dir"

      # Write to a temp file on the SAME filesystem/dir for atomic rename
      tmp="$(mktemp "$target.tmp.XXXXXX")"

      # Populate temp file (no truncation of the target)
      cat > "$tmp" <<'EOF'
      ${macOSPolicyContent}
      EOF

      # Validate plist before we touch the real file
      /usr/bin/plutil -lint "$tmp"

      # Set perms on the temp first
      chown root:wheel "$tmp"
      chmod 0644 "$tmp"

      mv -f "$tmp" "$target"
    '';
  };
}
