# Hyprland window manager configuration

{ lib, pkgs, ... }:

{
  imports = [
    ./waybar.nix
    ./wofi.nix
  ];

  # Only apply Hyprland configuration on Linux
  config = lib.mkIf pkgs.stdenv.isLinux {
    # Cursor theme configuration
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "macOS";
      package = pkgs.apple-cursor;
      size = 24;
    };

    # GTK theme configuration
    gtk = {
      enable = true;
      iconTheme = {
        name = "WhiteSur";
        package = pkgs.whitesur-icon-theme;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    # Ensure dconf is enabled for GTK apps
    dconf.enable = true;
    # Enable Hyprland
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        # Monitor configuration for single ultrawide (auto-detect monitor name)
        monitor = [
          ",3440x1440@144,0x0,1" # Physical ultrawide monitor
          # Headless display created dynamically with: hyprctl output create headless
        ];

        # General configuration
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "rgba(5CB6F8ff) rgba(0a7acaff) 45deg"; # VSCode lightblue to blue gradient
          "col.inactive_border" = "rgba(666666ff)"; # VSCode inactive
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };

        # Decoration settings
        decoration = {
          rounding = 0;

          shadow = {
            enabled = true;
            range = 2;
            render_power = 3;
            color = "rgba(262626ee)"; # VSCode bg color for shadow
          };

          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        # Animations
        animations = {
          enabled = true;

          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];

          animation = [
            "global,1,10,default"
            "border,1,5.39,easeOutQuint"
            "windows,1,4.79,easeOutQuint"
            "windowsIn,1,4.1,easeOutQuint,popin 87%"
            "windowsOut,1,1.49,linear,popin 87%"
            "fadeIn,1,1.73,almostLinear"
            "fadeOut,1,1.46,almostLinear"
            "fade,1,3.03,quick"
            "layers,1,3.81,easeOutQuint"
            "layersIn,1,4,easeOutQuint,fade"
            "layersOut,1,1.5,linear,fade"
            "fadeLayersIn,1,1.79,almostLinear"
            "fadeLayersOut,1,1.39,almostLinear"
            "workspaces,0,0,ease"
          ];
        };

        # Dwindle layout configuration
        dwindle = {
          pseudotile = true;
          preserve_split = true;
          force_split = 2; # Always split on the right
        };

        # Master layout configuration
        master = {
          new_status = "master";
        };

        # Input configuration
        input = {
          kb_layout = "us";
          follow_mouse = 1; # Focus follows mouse cursor
          mouse_refocus = false; # Don't refocus when mouse moves over windows
          sensitivity = -.8; # -1.0 - 1.0, negative values slow down mouse
        };

        # Workspace configuration (4 workspaces)
        workspace = [
          "1,default:true"
          "2"
          "3"
          "4"
        ];

        # Layer rules (application-specific animation)
        layerrule = [
          "noanim,wofi"
          "noanim,selection" # Remove 1px border around screenshots
        ];

        # Window rules
        windowrulev2 = [
          "float, class:^(wofi)$"
          "float, class:^(nautilus)$" # Keep file manager floating initially
        ];

        # Misc settings
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          focus_on_activate = true;
          background_color = "0x1e1e2e"; # Dark background color (Catppuccin Mocha base)
        };

        # Cursor settings
        cursor = {
          no_warps = false; # Enable cursor warping to center of focused windows
        };

        # Environment variables for cursor theme
        env = [
          "XCURSOR_THEME,macOS"
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_THEME,macOS" # Hyprland-specific cursor
          "HYPRCURSOR_SIZE,24"
        ];

        # Startup applications
        exec-once = [
          "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
        ];

        # Keybindings (translated from Pop Shell)
        bind = [
          # Application launcher (replaces Ulauncher)
          "SUPER, A, exec, wofi --show drun"

          # Window management - Mac-style
          "SUPER, W, killactive," # Close window (Mac Cmd+W)
          "SUPER, Q, exec, hyprctl dispatch exit" # Quit (Mac Cmd+Q style)

          # Window focus (matching Pop Shell j/k/l/semicolon pattern)
          "SUPER, J, movefocus, l" # Focus left
          "SUPER, K, movefocus, d" # Focus down
          "SUPER, L, movefocus, u" # Focus up
          "SUPER, semicolon, movefocus, r" # Focus right

          # Window movement (global - works across workspaces)
          "SUPER_SHIFT, J, movewindow, l" # Move left
          "SUPER_SHIFT, K, movewindow, d" # Move down
          "SUPER_SHIFT, L, movewindow, u" # Move up
          "SUPER_SHIFT, semicolon, movewindow, r" # Move right

          # Window resizing
          "SUPER, minus, resizeactive, -10 0" # Resize left
          "SUPER, equal, resizeactive, 10 0" # Resize right

          # Tiling controls
          "SUPER, Y, togglefloating," # Toggle tiling (Pop Shell's toggle-tiling)
          "SUPER, Return, pseudo," # Tile enter (pseudo-tiling)
          "SUPER, Escape, killactive," # Tile reject

          # Fullscreen toggle
          "SUPER, D, fullscreen," # Toggle fullscreen

          # Workspace switching
          "SUPER, 1, workspace, 1"
          "SUPER, 2, workspace, 2"
          "SUPER, 3, workspace, 3"
          "SUPER, 4, workspace, 4"
          "SUPER, Page_Up, workspace, -1" # Previous workspace
          "SUPER, Page_Down, workspace, +1" # Next workspace

          # Move window to workspace
          "SUPER_SHIFT, 1, movetoworkspace, 1"
          "SUPER_SHIFT, 2, movetoworkspace, 2"
          "SUPER_SHIFT, 3, movetoworkspace, 3"
          "SUPER_SHIFT, 4, movetoworkspace, 4"

          # Application switching
          "ALT, Tab, cyclenext,"
          "ALT_SHIFT, Tab, cyclenext, prev"
        ];

        # Mouse bindings
        bindm = [
          "SUPER, mouse:272, movewindow"
          "SUPER, mouse:273, resizewindow"
        ];
      };
    };

    # Install required packages
    home.packages = with pkgs; [
      # Hyprland ecosystem
      waybar
      wofi
      wl-clipboard
      networkmanagerapplet

      # Keep essential applications
      nautilus
    ];

    # Set cursor theme environment variables globally
    home.sessionVariables = {
      XCURSOR_THEME = "macOS";
      XCURSOR_SIZE = "24";
      HYPRCURSOR_THEME = "macOS";
      HYPRCURSOR_SIZE = "24";
    };
  };
}
