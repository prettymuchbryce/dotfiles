{ config, pkgs, lib, ... }:
{
  # Only configure Karabiner on macOS
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.file.".config/karabiner".source = ./config;
  };
}
