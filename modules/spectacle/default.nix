{ config, pkgs, ... }:
{
  home.file."Library/Application Support/Spectacle/Shortcuts.json".source = ./config/Shortcuts.json;
}
