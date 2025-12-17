{
  config,
  pkgs,
  lib,
  ...
}:
let
  format = pkgs.formats.json { };
in
{
  imports = [
    # Shared modules (cross-platform)
    ./modules/home/aws.nix
    ./modules/home/cli.nix
    ./modules/home/ghostty.nix
    ./modules/home/git.nix
    ./modules/home/go.nix
    ./modules/home/nvim
    ./modules/home/zellij.nix
    ./modules/home/zsh
    ./modules/home/fnm.nix
    ./modules/home/try.nix
    ./modules/home/rust.nix
    # Platform-specific modules
    ./modules/home/aerospace
    ./modules/home/karabiner
    ./modules/home/hyprland
    ./modules/home/claude-code.nix
    ./modules/home/mako.nix
    ./modules/home/codex.nix
    ./modules/home/amp.nix
    ./modules/home/mistral-vibe.nix
  ];

  # Option for simple OpenSnitch rules (consistent with system modules)
  options.opensnitchRules = lib.mkOption {
    type = lib.types.listOf (lib.types.attrsOf lib.types.anything);
    default = [ ];
    description = "Simple OpenSnitch rules that will be converted to verbose format automatically";
    example = [
      {
        name = "Allow SSH to GitHub";
        process = "/usr/bin/ssh";
        port = 22;
        host = "github.com";
        protocol = "tcp";
      }
    ];
  };

  options.persistenceDirectories = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = ''
      User directories to persist (relative to home directory).
      These will be collected by the system persistence module.
    '';
  };

  options.persistenceFiles = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = ''
      User files to persist (relative to home directory).  
      These will be collected by the system persistence module.
    '';
  };

  config = {
    targets.darwin.linkApps.enable = lib.mkIf pkgs.stdenv.isDarwin true;
    targets.darwin.linkApps.directory = "Applications";

    programs.home-manager.enable = true;

    home.packages =
      with pkgs;
      [
        pkgs.nerd-fonts.fira-code
        pkgs.nerd-fonts.jetbrains-mono
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        gcc # C compiler for neovim plugins
      ];

    # XDG configuration for Flatpak desktop integration
    xdg.systemDirs.data = lib.optionals pkgs.stdenv.isLinux [
      "/var/lib/flatpak/exports/share"
    ];

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.05"; # Please read the comment before changing.
  };
}