# GNOME desktop environment configuration

{ lib, pkgs, ... }:

{
  # Only apply GNOME configuration on Linux
  config = lib.mkIf pkgs.stdenv.isLinux {
    # Enable dconf for GNOME settings management
    dconf = {
      enable = true;
      settings = {
        # Mouse and touchpad settings
        "org/gnome/desktop/peripherals/mouse" = {
          "natural-scroll" = false;
          "speed" = -0.5; # Adjust mouse sensitivity (-1.0 to 1.0)
        };

        # Interface and appearance
        "org/gnome/desktop/interface" = {
          "color-scheme" = "prefer-dark";
          "gtk-theme" = "Adwaita-dark";
          "icon-theme" = "Adwaita";
          "show-battery-percentage" = true;
          "clock-show-weekday" = true;
          "clock-show-date" = true;
        };

        "org/gnome/shell/keybindings" = {
          "toggle-application-view" = [ ];
          "switch-to-application-1" = [ ];
          "switch-to-application-2" = [ ];
          "switch-to-application-3" = [ ];
          "switch-to-application-4" = [ ];
          "switch-to-application-5" = [ ];
          "switch-to-application-6" = [ ];
          "switch-to-application-7" = [ ];
          "switch-to-application-8" = [ ];
          "switch-to-application-9" = [ ];
        };

        # Enable GNOME Shell extensions
        "org/gnome/shell" = {
          "enabled-extensions" = [
            "pop-shell@system76.com"
            "dash-to-dock@micxgx.gmail.com"
            "appindicatorsupport@rgcjonas.gmail.com"
            "dim-background-windows@stephane-13.github.com"
          ];
        };

        # Configure Dash to Dock to not conflict with Pop Shell
        "org/gnome/shell/extensions/dash-to-dock" = {
          "hot-keys" = false; # Disable Super+1-9 hotkeys for dock
        };

        # Configure Dim Background Windows extension for macOS-like focus indication
        "org/gnome/shell/extensions/dim-background-windows" = {
          "brightness" = 0.9;
          "saturation" = 0.9;
        };

        # Window management - let Pop Shell handle most shortcuts
        "org/gnome/desktop/wm/keybindings" = {
          # Keep basic GNOME shortcuts that don't conflict with Pop Shell
          "close" = [ "<Super>w" ]; # Close window (Mac-style Cmd+W)
          "cycle-windows" = [ "<Alt>Tab" ];
          "cycle-windows-backward" = [ "<Alt><Shift>Tab" ];

          # Disable conflicting shortcuts that Pop Shell will handle
          "move-to-side-w" = [ ];
          "move-to-side-e" = [ ];
          "maximize" = [ ];
          "unmaximize" = [ ];
          "toggle-fullscreen" = [ ];

          # Disable all workspace switching shortcuts (Pop Shell handles these)
          "switch-to-workspace-1" = [ ];
          "switch-to-workspace-2" = [ ];
          "switch-to-workspace-3" = [ ];
          "switch-to-workspace-4" = [ ];
          "switch-to-workspace-5" = [ ];
          "switch-to-workspace-6" = [ ];
          "switch-to-workspace-7" = [ ];
          "switch-to-workspace-8" = [ ];
          "switch-to-workspace-9" = [ ];
          "switch-to-workspace-up" = [ ];
          "switch-to-workspace-down" = [ ];

          # Disable all move-to-workspace shortcuts (Pop Shell handles these)
          "move-to-workspace-1" = [ ];
          "move-to-workspace-2" = [ ];
          "move-to-workspace-3" = [ ];
          "move-to-workspace-4" = [ ];
          "move-to-workspace-5" = [ ];
          "move-to-workspace-6" = [ ];
          "move-to-workspace-7" = [ ];
          "move-to-workspace-8" = [ ];
          "move-to-workspace-9" = [ ];
        };

        # Custom keybindings
        "org/gnome/settings-daemon/plugins/media-keys" = {
          "custom-keybindings" = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
          ];
        };

        # Ulauncher shortcut (Raycast alternative)
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          "binding" = "<Super>a";
          "command" = "ulauncher-toggle";
          "name" = "Launch Ulauncher";
        };

        # Quit application shortcut (Mac-style Cmd+Q)
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
          "binding" = "<Super>q";
          "command" = "xdotool getwindowfocus key --window %1 ctrl+q";
          "name" = "Quit Application";
        };

        # Workspaces
        "org/gnome/desktop/wm/preferences" = {
          "num-workspaces" = 4;
        };

        "org/gnome/mutter" = {
          "dynamic-workspaces" = false;
          "workspaces-only-on-primary" = true;
          "overlay-key" = ""; # Disable Super key overlay to prevent conflicts
        };

        # Disable animations for snappier feel
        "org/gnome/desktop/interface" = {
          "enable-animations" = false;
        };

        # Privacy settings
        "org/gnome/desktop/privacy" = {
          "disable-microphone" = false;
          "disable-camera" = false;
          "remember-recent-files" = false;
          "remember-app-usage" = false;
        };

        # File manager settings
        "org/gnome/nautilus/preferences" = {
          "default-folder-viewer" = "list-view";
          "search-filter-time-type" = "last_modified";
          "show-hidden-files" = true;
        };

        # Session settings
        "org/gnome/desktop/session" = {
          "idle-delay" = 900; # 15 minutes before idle
        };

        # Power settings
        "org/gnome/settings-daemon/plugins/power" = {
          "sleep-inactive-ac-type" = "nothing";
          "sleep-inactive-battery-type" = "suspend";
          "sleep-inactive-battery-timeout" = 1800; # 30 minutes
        };
      };
    };

    # Install GNOME extensions and tools
    home.packages = with pkgs; [
      gnomeExtensions.pop-shell
      gnomeExtensions.dim-background-windows

      # Useful GNOME tools
      dconf-editor
      gnome-tweaks

      # Additional productivity tools
      gnomeExtensions.dash-to-dock
      gnomeExtensions.appindicator
    ];
  };
}
