{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    # utilities
    gnumake
    libiconv
    ripgrep
    jq
    unrar
    ffmpeg
    portaudio
    imagemagick
    llvm
    lld
    mold
    cmake
    duckdb

    # python
    uv
    python3

    # nix
    nixfmt

    # app dev
    awslogs
    git-crypt
    lua

    shfmt
    tenv
    tmux

    # Click 8.2.0 introduced changes which broke many packages.
    # So avoid running the tests for now.
    (python3Packages.yamlfix.overridePythonAttrs (_: {
      doCheck = false;
    }))
  ];

  home.file.".config/uv/uv.toml".text = ''
    exclude-newer = "1 week"
  '';

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
    package = pkgs.direnv.overrideAttrs (old: {
      env = (old.env or { }) // {
        CGO_ENABLED = 1;
      };
    });
  };
}
