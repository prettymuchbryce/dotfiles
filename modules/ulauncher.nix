# Ulauncher configuration (Raycast alternative for Linux)

{ lib, pkgs, config, ... }:

{
  # Only configure Ulauncher on Linux systems
  config = lib.mkIf pkgs.stdenv.isLinux {
    home.packages = [ pkgs.ulauncher ];

    # Ulauncher configuration
    home.file.".config/ulauncher/settings.json".text = builtins.toJSON {
      "blacklisted-desktop-dirs" = "/usr/share/locale:/usr/share/app-install:/usr/share/kservices5:/usr/share/fk5";
      "clear-previous-query" = true;
      "hotkey-show-app" = "<Super>space";
      "render-on-screen" = "mouse-pointer-monitor";
      "show-indicator-icon" = true;
      "show-recent-apps" = "3";
      "terminal-command" = "ghostty";
      "theme-name" = "dark";
      "disable-desktop-filters" = false;
    };

    # Ulauncher shortcuts configuration
    home.file.".config/ulauncher/shortcuts.json".text = builtins.toJSON {
      "shortcuts" = {
        # Quick shortcuts similar to Raycast
        "g" = {
          "added" = 1640995200;
          "cmd" = "https://google.com/search?q=%s";
          "is_default_search" = true;
          "keyword" = "g";
          "name" = "Google Search";
        };
        "gh" = {
          "added" = 1640995200;
          "cmd" = "https://github.com/search?q=%s";
          "is_default_search" = false;
          "keyword" = "gh";
          "name" = "GitHub Search";
        };
        "calc" = {
          "added" = 1640995200;
          "cmd" = "python3 -c \"print(%s)\"";
          "is_default_search" = false;
          "keyword" = "calc";
          "name" = "Calculator";
        };
      };
    };

    # Enable autostart for Ulauncher
    home.file.".config/autostart/ulauncher.desktop".text = ''
      [Desktop Entry]
      Name=Ulauncher
      Comment=Application launcher for Linux
      GenericName=Launcher
      Categories=GNOME;GTK;Utility;
      TryExec=ulauncher
      Exec=env GDK_BACKEND=x11 ulauncher --hide-window
      Icon=ulauncher
      Terminal=false
      Type=Application
      X-GNOME-Autostart-enabled=true
    '';
  };
}