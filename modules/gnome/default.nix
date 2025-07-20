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
          "speed" = -0.3; # Adjust mouse sensitivity (-1.0 to 1.0)
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

        # Window management and tiling
        "org/gnome/desktop/wm/keybindings" = {
          # Basic window tiling (similar to AeroSpace shortcuts)
          "move-to-side-w" = [ "<Super>Left" ];
          "move-to-side-e" = [ "<Super>Right" ];
          "maximize" = [ "<Super>Up" ];
          "unmaximize" = [ "<Super>Down" ];

          # Workspace switching
          "switch-to-workspace-1" = [ "<Super>1" ];
          "switch-to-workspace-2" = [ "<Super>2" ];
          "switch-to-workspace-3" = [ "<Super>3" ];
          "switch-to-workspace-4" = [ "<Super>4" ];

          # Move windows to workspaces
          "move-to-workspace-1" = [ "<Super><Shift>1" ];
          "move-to-workspace-2" = [ "<Super><Shift>2" ];
          "move-to-workspace-3" = [ "<Super><Shift>3" ];
          "move-to-workspace-4" = [ "<Super><Shift>4" ];

          # Window closing and cycling
          "close" = [ "<Super>q" ];
          "cycle-windows" = [ "<Alt>Tab" ];
          "cycle-windows-backward" = [ "<Alt><Shift>Tab" ];
        };

        # Custom keybindings
        "org/gnome/settings-daemon/plugins/media-keys" = {
          "custom-keybindings" = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          ];
        };

        # Ulauncher shortcut (Raycast alternative)
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          "binding" = "<Super>space";
          "command" = "ulauncher-toggle";
          "name" = "Launch Ulauncher";
        };

        # Workspaces
        "org/gnome/desktop/wm/preferences" = {
          "num-workspaces" = 4;
        };

        "org/gnome/mutter" = {
          "dynamic-workspaces" = false;
          "workspaces-only-on-primary" = true;
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

    # Install GNOME extensions
    home.packages = with pkgs; [
      # Application launcher (Raycast alternative)
      ulauncher

      # GNOME extensions for enhanced window tiling
      gnomeExtensions.tiling-assistant
      gnomeExtensions.forge
      gnomeExtensions.pop-shell

      # Useful GNOME tools
      dconf-editor
      gnome-tweaks

      # Additional productivity tools
      gnomeExtensions.dash-to-dock
      gnomeExtensions.appindicator
    ];
  };
}

