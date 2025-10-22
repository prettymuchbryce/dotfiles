# Waybar configuration for Hyprland

{ lib, pkgs, ... }:

{
  config = lib.mkIf pkgs.stdenv.isLinux {
    programs.waybar = {
      enable = true;

      # Enable systemd integration with proper target for Hyprland
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };

      # Source the configuration from external file
      settings = {
        mainBar = builtins.fromJSON (builtins.readFile ./waybar/config);
      };

      # Source the style from external CSS file
      style = builtins.readFile ./waybar/style.css;
    };
  };
}

