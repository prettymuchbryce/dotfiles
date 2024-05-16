# darwin.nix

{ pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ pkgs.vim ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

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
      "brave-browser"
      "docker"
      "iterm2"
      "karabiner-elements"
      "raycast"
      "signal"
      "signal"
      "slack"
      "spectacle"
      "telegram"
      "amethyst"
      "ollama"
      "spotify"
      "protonvpn"
    ];
  };

  # System settings
  system.defaults.NSGlobalDomain.AppleShowAllFiles = true;
  system.defaults.NSGlobalDomain._HIHideMenuBar = false;
  system.defaults.dock.autohide = true;
  system.defaults.dock.tilesize = 64;
  system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;
  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
}
