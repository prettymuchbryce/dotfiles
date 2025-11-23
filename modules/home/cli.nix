{ pkgs, pkgs-solana, lib, ... }:
{
  home.packages = with pkgs; [
    # utilities
    gnumake
    libiconv
    ripgrep
    jq
    unrar
    ffmpeg
    imagemagick

    # python
    uv
    (python3.withPackages (
      ps: with ps; [
        setuptools
        pip
        openai
        pipx
      ]
    ))

    # nix
    nixfmt-rfc-style

    # app dev
    awslogs
    git-crypt
    pkgs-solana.solana-cli  # Use older version from nixos-24.11
    lua
    rustup
    shfmt
    tenv

    # Click 8.2.0 introduced changes which broke many packages.
    # So avoid running the tests for now.
    (python3Packages.yamlfix.overridePythonAttrs (_: {
      doCheck = false;
    }))
  ];

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;

    enableSshSupport = false;
    enableExtraSocket = true;

    # Set pinentry package based on platform
    pinentry.package = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-gtk2;

    # Cache TTL settings
    defaultCacheTtl = 3600; # 1 hour
    maxCacheTtl = 86400; # 24 hours

    extraConfig = ''
      allow-loopback-pinentry
      allow-preset-passphrase
    '';
  };

  programs.mods = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
