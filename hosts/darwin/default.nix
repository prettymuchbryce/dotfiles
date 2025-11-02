# darwin.nix

{ pkgs, ... }:

{
  imports = [
    ../../modules/system/brave.nix
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = "bryce";

  users.users.bryce = {
    name = "bryce";
    home = "/Users/bryce";
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };

    casks = [
      "audacity"
      "docker"
      "karabiner-elements"
      "nikitabobko/tap/aerospace"
      "ollama"
      "protonvpn"
      "raycast"
      "signal"
      "slack"
      "spotify"
      "telegram"
      "vlc"
      "zoom"
      "figma"
      "notion"
      "discord"
      "ghostty"
    ];
  };

  # System settings
  power.sleep.display = 10;
  system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;
  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.AppleShowAllFiles = true;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  system.defaults.NSGlobalDomain._HIHideMenuBar = true;
  system.defaults.WindowManager.StageManagerHideWidgets = true;
  system.defaults.WindowManager.StandardHideWidgets = true;
  system.defaults.dock.autohide = true;
  system.defaults.dock.tilesize = 64;
  system.defaults.universalaccess.reduceMotion = true;
  system.defaults.universalaccess.reduceTransparency = true;
  system.defaults.CustomUserPreferences.".GlobalPreferences" = {
    AppleReduceDesktopTinting = true;
  };

  # No hot corners
  system.defaults.dock.wvous-tl-corner = 1;
  system.defaults.dock.wvous-bl-corner = 1;
  system.defaults.dock.wvous-tr-corner = 1;
  system.defaults.dock.wvous-br-corner = 1;

  # No system sounds
  system.defaults.NSGlobalDomain."com.apple.sound.beep.feedback" = 0;
  system.defaults.NSGlobalDomain."com.apple.sound.beep.volume" = 0.0;

  # Key Repeat
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 2;

  # Trackpad
  system.defaults.trackpad.Clicking = true; # Tap to click
  system.defaults.trackpad.TrackpadRightClick = true; # Right click
}
