{ config, pkgs, lib, ... }:
{
  # Only configure Spectacle on macOS
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.file."Library/Application Support/Spectacle/Shortcuts.json".source = ./config/Shortcuts.json;
  };
}
