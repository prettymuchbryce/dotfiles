# Waybar configuration for Hyprland

{ lib, pkgs, ... }:

{
  config = lib.mkIf pkgs.stdenv.isLinux {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          spacing = 4;

          # Module layout
          modules-left = [
            "hyprland/workspaces"
            "hyprland/window"
          ];
          modules-center = [ ];
          modules-right = [
            "pulseaudio"
            "clock"
            "tray"
            "custom/power"
          ];

          # Workspaces
          "hyprland/workspaces" = {
            format = "{name}";
            format-icons = {
              "1" = "1";
              "2" = "2";
              "3" = "3";
              "4" = "4";
            };
            persistent-workspaces = {
              "*" = [
                1
                2
                3
                4
              ];
            };
          };

          # Window title
          "hyprland/window" = {
            format = "{}";
            max-length = 50;
            separate-outputs = true;
          };

          # Audio
          pulseaudio = {
            format = "{volume}% {icon}";
            format-muted = "🔇";
            format-icons = {
              headphone = "🎧";
              hands-free = "🎧";
              headset = "🎧";
              phone = "📞";
              portable = "📱";
              car = "🚗";
              default = [
                "🔈"
                "🔉"
                "🔊"
              ];
            };
            on-click = "pavucontrol";
          };

          # Clock
          clock = {
            interval = 1;
            format = "{:%m/%d/%y %I:%M:%S %p}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };

          # Power management
          "custom/power" = {
            format = "⏻";
            tooltip = "Power Options";
            on-click = "echo -e 'Lock\nLogout\nSuspend\nReboot\nShutdown' | wofi --show=dmenu --prompt='Power' --width=200 --height=150 --cache-file=/dev/null --location=top_right --xoffset=-10 --yoffset=0 | xargs -I {} sh -c 'case {} in Lock) hyprlock ;; Logout) hyprctl dispatch exit ;; Suspend) systemctl suspend ;; Reboot) systemctl reboot ;; Shutdown) systemctl poweroff ;; esac'";
          };

          # System tray
          tray = {
            icon-size = 21;
            spacing = 10;
          };
        };
      };

      # VS Code inspired dark theme
      style = ''
        * {
          font-family: "JetBrains Mono", monospace;
          font-size: 13px;
          font-weight: normal;
        }

        window#waybar {
          background-color: #1e1e1e;
          border-bottom: 0px;
          color: #d4d4d4;
        }

        button {
          box-shadow: inset 0 -3px transparent;
          border: none;
          border-radius: 0;
        }

        #workspaces button {
          padding: 0 8px;
          background-color: transparent;
          color: #d4d4d4;
        }

        #workspaces button:hover {
          background: rgba(86, 156, 214, 0.2);
        }

        #workspaces button.active {
          background-color: #569cd6;
          color: #1e1e1e;
        }

        #workspaces button.urgent {
          background-color: #f14c4c;
        }

        #window {
          color: #ce9178;
          font-weight: bold;
        }

        #clock,
        #pulseaudio,
        #custom-power,
        #tray {
          padding: 0 10px;
          background-color: #2d2d30;
          color: #d4d4d4;
          margin: 3px 3px;
          border-radius: 3px;
        }

        #clock {
          color: #4ec9b0;
        }

        #pulseaudio {
          color: #c586c0;
        }

        #pulseaudio.muted {
          color: #808080;
        }

        #tray {
          background-color: #2d2d30;
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #f14c4c;
        }

        #custom-power {
          color: #f44747;
          font-weight: bold;
        }

        #custom-power:hover {
          background-color: rgba(244, 71, 71, 0.2);
        }
      '';
    };
  };
}
