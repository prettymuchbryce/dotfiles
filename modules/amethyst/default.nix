{ config, pkgs, ... }:
{
  home.file.".amethyst.yml".source = ./config/.amethyst.yml;
}
