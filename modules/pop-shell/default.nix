{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Only enable on Linux systems
  config = lib.mkIf pkgs.stdenv.isLinux {
    dconf.settings = {
      # Pop Shell extension settings
      "org/gnome/shell/extensions/pop-shell" = {
        tile-by-default = true;
        active-hint = true;
        hint-color-rgba = "rgb(251,184,108)";
        gap-inner = lib.hm.gvariant.mkUint32 0;
        gap-outer = lib.hm.gvariant.mkUint32 0;
        smart-gaps = false;
        snap-to-grid = false;

        # Keybindings translated from Aerospace
        toggle-tiling = [
          "<Super>y"
          "<Alt><Ctrl><Shift>Return"
        ];
        tile-enter = [ "<Super>Return" ];
        tile-reject = [ "<Super>Escape" ];

        # Window swapping
        tile-swap-left = [ "<Super><Shift>Left" ];
        tile-swap-right = [ "<Super><Shift>Right" ];
        tile-swap-up = [ "<Super><Shift>Up" ];
        tile-swap-down = [ "<Super><Shift>Down" ];

        # Window resizing (translated from alt-ctrl-shift-minus/equal)
        tile-resize-left = [
          "<Super>minus"
          "<Alt><Ctrl><Shift>minus"
        ];
        tile-resize-right = [
          "<Super>equal"
          "<Alt><Ctrl><Shift>equal"
        ];

        # Window focus (alt-ctrl-shift + hjkl pattern)
        focus-left = [
          "<Super>h"
          "<Alt><Ctrl><Shift>j"
        ];
        focus-down = [
          "<Super>j"
          "<Alt><Ctrl><Shift>k"
        ];
        focus-up = [
          "<Super>k"
          "<Alt><Ctrl><Shift>l"
        ];
        focus-right = [
          "<Super>l"
          "<Alt><Ctrl><Shift>semicolon"
        ];

        # Window movement within workspace (alt-ctrl-cmd-shift + hjkl)
        tile-move-left = [
          "<Super><Shift>h"
          "<Alt><Ctrl><Cmd><Shift>j"
        ];
        tile-move-down = [
          "<Super><Shift>j"
          "<Alt><Ctrl><Cmd><Shift>k"
        ];
        tile-move-up = [
          "<Super><Shift>k"
          "<Alt><Ctrl><Cmd><Shift>l"
        ];
        tile-move-right = [
          "<Super><Shift>l"
          "<Alt><Ctrl><Cmd><Shift>semicolon"
        ];
      };

      # GNOME WM keybindings - translated from Aerospace
      "org/gnome/desktop/wm/keybindings" = {
        # Fullscreen toggle (alt-ctrl-shift-d)
        toggle-fullscreen = [
          "<Super>F11"
          "<Alt><Ctrl><Shift>d"
        ];

        # Workspace switching (alt-ctrl-shift + numbers)
        switch-to-workspace-1 = [
          "<Super>1"
          "<Alt><Ctrl><Shift>1"
        ];
        switch-to-workspace-2 = [
          "<Super>2"
          "<Alt><Ctrl><Shift>2"
        ];
        switch-to-workspace-3 = [
          "<Super>3"
          "<Alt><Ctrl><Shift>3"
        ];
        switch-to-workspace-4 = [
          "<Super>4"
          "<Alt><Ctrl><Shift>4"
        ];
        switch-to-workspace-5 = [
          "<Super>5"
          "<Alt><Ctrl><Shift>5"
        ];
        switch-to-workspace-6 = [
          "<Super>6"
          "<Alt><Ctrl><Shift>6"
        ];
        switch-to-workspace-7 = [
          "<Super>7"
          "<Alt><Ctrl><Shift>7"
        ];
        switch-to-workspace-8 = [
          "<Super>8"
          "<Alt><Ctrl><Shift>8"
        ];
        switch-to-workspace-9 = [
          "<Super>9"
          "<Alt><Ctrl><Shift>9"
        ];

        # Move window to workspace (alt-ctrl-cmd-shift + numbers)
        move-to-workspace-1 = [
          "<Super><Shift>1"
          "<Alt><Ctrl><Cmd><Shift>1"
        ];
        move-to-workspace-2 = [
          "<Super><Shift>2"
          "<Alt><Ctrl><Cmd><Shift>2"
        ];
        move-to-workspace-3 = [
          "<Super><Shift>3"
          "<Alt><Ctrl><Cmd><Shift>3"
        ];
        move-to-workspace-4 = [
          "<Super><Shift>4"
          "<Alt><Ctrl><Cmd><Shift>4"
        ];
        move-to-workspace-5 = [
          "<Super><Shift>5"
          "<Alt><Ctrl><Cmd><Shift>5"
        ];
        move-to-workspace-6 = [
          "<Super><Shift>6"
          "<Alt><Ctrl><Cmd><Shift>6"
        ];
        move-to-workspace-7 = [
          "<Super><Shift>7"
          "<Alt><Ctrl><Cmd><Shift>7"
        ];
        move-to-workspace-8 = [
          "<Super><Shift>8"
          "<Alt><Ctrl><Cmd><Shift>8"
        ];
        move-to-workspace-9 = [
          "<Super><Shift>9"
          "<Alt><Ctrl><Cmd><Shift>9"
        ];

        # Next/Previous workspace (alt-ctrl-shift + up/down)
        switch-to-workspace-up = [
          "<Super>Page_Up"
          "<Alt><Ctrl><Shift>Up"
        ];
        switch-to-workspace-down = [
          "<Super>Page_Down"
          "<Alt><Ctrl><Shift>Down"
        ];

        # Application switching (keep alt-tab behavior and add Super variant)
        switch-applications = [
          "<Alt>Tab"
          "<Super>Tab"
        ];

        # Disable conflicting shortcuts to allow ulauncher Super+Space
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
