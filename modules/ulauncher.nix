# Ulauncher configuration (Raycast alternative for Linux)

{
  lib,
  pkgs,
  config,
  ...
}:

let
  # Minimal configuration - just hotkey and theme
  settingsJson = builtins.toJSON {
    "hotkey-show-app" = "<Super>a";
    "theme-name" = "dark";
  };
in
{
  # Only configure Ulauncher on Linux systems
  config = lib.mkIf pkgs.stdenv.isLinux {
    home.packages = [ pkgs.ulauncher ];

    # Minimal activation script - only set hotkey and theme
    home.activation.ulauncher = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Create ulauncher config directory
      mkdir -p ~/.config/ulauncher

      # Only create initial config if files don't exist or are symlinks
      if [ ! -f ~/.config/ulauncher/settings.json ] || [ -L ~/.config/ulauncher/settings.json ]; then
        rm -f ~/.config/ulauncher/settings.json
        echo '${settingsJson}' > ~/.config/ulauncher/settings.json
      fi
    '';

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
