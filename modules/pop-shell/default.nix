{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Only enable on Linux systems
  config = lib.mkIf pkgs.stdenv.isLinux {
    # Pop Shell JSON configuration for floating windows
    xdg.configFile."pop-shell/config.json".text = builtins.toJSON {
      float = [
        {
          class = "ulauncher";
          title = "";
        }
        {
          class = "Ulauncher";
          title = "";
        }
        {
          class = "python3";
          title = "Ulauncher";
        }
      ];
      log_on_focus = false;
    };

    dconf.settings = {
      # Pop Shell extension settings
      "org/gnome/shell/extensions/pop-shell" = {
        tile-by-default = true;
        active-hint = false;
        gap-inner = lib.hm.gvariant.mkUint32 0;
        gap-outer = lib.hm.gvariant.mkUint32 0;
        smart-gaps = false;
        snap-to-grid = false;

        # Keybindings using Super key for Linux ergonomics
        toggle-tiling = [ "<Super>y" ];
        tile-enter = [ "<Super>Return" ];
        tile-reject = [ "<Super>Escape" ];

        # Window swapping
        tile-swap-left = [ "<Super><Shift>Left" ];
        tile-swap-right = [ "<Super><Shift>Right" ];
        tile-swap-up = [ "<Super><Shift>Up" ];
        tile-swap-down = [ "<Super><Shift>Down" ];

        # Window resizing
        tile-resize-left = [ "<Super>minus" ];
        tile-resize-right = [ "<Super>equal" ];
        tile-resize-down = [ ];
        tile-resize-up = [ ];

        # Window focus (jkl; pattern matching Aerospace)
        focus-left = [ "<Super>j" ];
        focus-down = [ "<Super>k" ];
        focus-up = [ "<Super>l" ];
        focus-right = [ "<Super>semicolon" ];

        # Window movement (global - works across workspaces)
        tile-move-left-global = [ "<Super><Shift>j" ];
        tile-move-down-global = [ "<Super><Shift>k" ];
        tile-move-up-global = [ "<Super><Shift>l" ];
        tile-move-right-global = [ "<Super><Shift>semicolon" ];

        # Disable conflicting bindings
        pop-workspace-down = [ ];
        pop-workspace-up = [ ];
      };

      # GNOME WM keybindings - translated from Aerospace
      "org/gnome/desktop/wm/keybindings" = {
        # Fullscreen toggle
        toggle-fullscreen = [ "<Super>d" ];

        # Workspace switching
        switch-to-workspace-1 = [ "<Super>1" ];
        switch-to-workspace-2 = [ "<Super>2" ];
        switch-to-workspace-3 = [ "<Super>3" ];
        switch-to-workspace-4 = [ "<Super>4" ];
        switch-to-workspace-5 = [ "<Super>5" ];
        switch-to-workspace-6 = [ "<Super>6" ];
        switch-to-workspace-7 = [ "<Super>7" ];
        switch-to-workspace-8 = [ "<Super>8" ];
        switch-to-workspace-9 = [ "<Super>9" ];

        # Move window to workspace
        move-to-workspace-1 = [ "<Super><Shift>1" ];
        move-to-workspace-2 = [ "<Super><Shift>2" ];
        move-to-workspace-3 = [ "<Super><Shift>3" ];
        move-to-workspace-4 = [ "<Super><Shift>4" ];
        move-to-workspace-5 = [ "<Super><Shift>5" ];
        move-to-workspace-6 = [ "<Super><Shift>6" ];
        move-to-workspace-7 = [ "<Super><Shift>7" ];
        move-to-workspace-8 = [ "<Super><Shift>8" ];
        move-to-workspace-9 = [ "<Super><Shift>9" ];

        # Next/Previous workspace
        switch-to-workspace-up = [ "<Super>Page_Up" ];
        switch-to-workspace-down = [ "<Super>Page_Down" ];

        # Application switching
        switch-applications = [ "<Alt>Tab" ];

        # Disable conflicting shortcuts
        activate-window-menu = [ ];
        toggle-maximized = [ ];
        panel-main-menu = [ ];
      };

      # Disable GNOME Shell's overview key binding to allow ulauncher Super+Space
      "org/gnome/shell/keybindings" = {
        toggle-overview = [ ];
      };
    };
  };
}
