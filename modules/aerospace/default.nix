{ config, pkgs, ... }:
{
  home.file.".aerospace.toml".source = ./config/.aerospace.toml;
}
