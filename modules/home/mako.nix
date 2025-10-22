{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Only enable mako on Linux systems
  # Used by antivirus notifications
  config = lib.mkIf pkgs.stdenv.isLinux {
    services.mako = {
      enable = true;

      settings = {
        # Styling - matching waybar theme
        background-color = "#000000";
        text-color = "#eeeeee";
        border-color = "#eeeeee";
        border-radius = 0;
        border-size = 1;

        # Positioning
        anchor = "top-right";
        default-timeout = 10000; # 10 seconds

        # Behavior
        ignore-timeout = false;
        max-visible = 5;

        # Typography - matching waybar
        font = "SFProDisplay Nerd Font 13";

        # Dimensions
        width = 350;
        height = 100;
        margin = "10";
        padding = "15";

        # Icons
        icon-path = "${config.home.homeDirectory}/.icons:${pkgs.hicolor-icon-theme}/share/icons/hicolor";
        max-icon-size = 48;
      };

      # Additional options
      extraConfig = ''
        # Urgency styling
        [urgency=low]
        border-color=#aaaaaa
        text-color=#aaaaaa
        default-timeout=5000

        [urgency=high]
        border-color=#ff0000
        text-color=#eeeeee
        default-timeout=0
      '';
    };
  };
}
