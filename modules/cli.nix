{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    awslogs
    git-crypt

    # Better alternatives
    ripgrep # grep

    # Structured data
    jq

    unrar

    # gnupg
    # pinentry-mac
  ];

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;

    # Platform-specific SSH support settings
    enableSshSupport = lib.mkDefault (!pkgs.stdenv.isDarwin); # Enable on Linux, disable on macOS to avoid conflicts
    enableExtraSocket = true;

    # Set pinentry package based on platform
    pinentryPackage = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-gtk2;

    # Cache TTL settings
    defaultCacheTtl = 3600; # 1 hour
    maxCacheTtl = 86400; # 24 hours

    extraConfig = ''
      allow-loopback-pinentry
      allow-preset-passphrase
    '';
  };

  programs.starship = {
    enable = true;
  };
}
