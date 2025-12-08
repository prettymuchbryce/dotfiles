# Brave

Installing Brave declaratively on Mac OS is a _hot pain in the asshole_.

I'll walk through some of the solutions I've tried to achieve this here and why they've all failed.

## Requirements

My requirements to manage my browser declaratively are two-fold.
1. The ability to set managed policies such as disabling brave rewards, brave wallet, enabling secure DNS, etc.
2. Installing extensions and ideally automatically pinning a subset of them to the browser bar.

## Option #1 - /Library/Managed Preferences

In a system module, it's possible to define a MacOS XML policy file which contains all of the policy settings, extensions, and extension pinning and write this to `/Library/Managed Preferences/com.brave.Browser.plist` during activation. This actually works. If you apply the configuration it will appear to have succeeded.

One downside of this approach is that Brave is now considered "fully managed" and settings can not be customized within Brave itself. Changes must be made in the configuration file.

### The problem

`/Library/Managed Preferences` on MacOS is functionally a **volatile cache**. It's regenerated from the configuration-profile/MDM database on restartb. Every time you login, reboot, or restart the system performs a background maintenance task which wipes and regenerates that directory to match the database.

If you're OK with having to re-apply your configuration on every restart then maybe this works for you. Your extension data will all be deleted as well, so you'll have to manually reconfigure anything you've changed there.

## Option #2 - Use `.mobileconfig`

Write a `.mobileconfig` file containing the policies and use `/user/bin/profiles` in an activation script to install it. The policy will no longer be in the volatile cache and therefore will not be removed upon restart.

### The problem

On recent versions of MacOS (such as Tahoe) Apple has **hard-deprecated** the ability to install Configuration profiles via the `profiles` CLI for security reasons. The workaround here is to generate the `.mobileconfig` file and manually install it. You will need to do this manually every time you change the Brave policy configuration in nix.

## Option #3 - Use home manager

You can utilize extension files by writing them to `~/Library/Application Support/BraveSoftware/Brave-Browser/External Extensions/`. This will prompt you to install the extensions when you open Brave for the first time. You can not pin them this way.

You could feasibly wrap the brave executable using policy flags.

```nix
home.packages = [
  (pkgs.symlinkJoin {
    name = "brave-custom";
    paths = [ pkgs.brave ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/brave \
        --add-flags "--disable-features=BraveRewards,BraveWallet,BraveVPN" \
        --add-flags "--no-default-browser-check"
    '';
  })
];
```

### The problem

This solution works, but it doesn't support all possible policies. Examples of flags that aren't possible are: `BraveStatsPing`, `BraveWebDiscovery`, `BraveP3AEnabled`, etc. This may be sufficient if you only need some common policies.

## Option #4 - User Preferences

You could write `~/Library/Preferences/com.brave.browser.plist` or run something like:

```sh
defaults write com.brave.Browser SomePolicyKey -bool true
````

These policies are often seen, but not enforced. Not all of them are supported at the user level (i.e. `BraveAIChatEnabled`, and `BraveWalletDisabled`). Multiple bug reports have been filed for this, and the behavior can be considered unpredictable at best.

## Option #5 - Give up

Give up on the idea of declaratively customizing Brave on MacOS. I recommend this solution until Brave improves support for Nix users on MacOS.

Policies I set manually through Brave settings.

```nix
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

      <!-- Enable secure DNS -->
      <key>DnsOverHttpsMode</key><string>secure</string>
      <key>DnsOverHttpsTemplates</key><string>${dnsServers}</string>
```
