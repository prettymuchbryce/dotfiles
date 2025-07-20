{ pkgs, ... }:
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

    # Disable SSH support to avoid conflicts with macOS SSH agent
    enableSshSupport = false;
    enableExtraSocket = true;

    # Set pinentry package to pinentry-mac
    pinentryPackage = pkgs.pinentry_mac;

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
