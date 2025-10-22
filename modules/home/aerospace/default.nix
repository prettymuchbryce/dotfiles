{ config, pkgs, lib, ... }:
{
  # Only configure AeroSpace on macOS
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.file.".aerospace.toml".source = ./config/.aerospace.toml;
  };
}
