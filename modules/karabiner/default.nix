{ config, pkgs, ... }:
{
  home.file.".config/karabiner".source = ./config;
}
