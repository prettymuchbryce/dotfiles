{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;

    settings = {
      shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [
          "--login"
          "-c"
          "${pkgs.zellij}/bin/zellij attach -c main"
        ];
      };

      env.TERM = "xterm-256color";

      window = {
        dimensions = {
          columns = 80;
          lines = 25;
        };
        padding = {
          x = 0;
          y = 0;
        };
        dynamic_title = true;
        decorations = "None";
        option_as_alt = "Both";
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      font = {
        normal = {
          family = "FiraCode Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "FiraCode Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "FiraCode Nerd Font";
          style = "Italic";
        };
        size = 16.0;
      };

      colors = {
        primary = {
          background = "0x1F1F1F";
          foreground = "0xD4D4D4";
        };
        cursor = {
          text = "0x1F1F1F";
          cursor = "0xAEAFAD";
        };
        normal = {
          black = "0x808080";
          red = "0xF44747";
          green = "0x6A9955";
          yellow = "0xDCDCAA";
          blue = "0x569CD6";
          magenta = "0xC586C0";
          cyan = "0x4EC9B0";
          white = "0xD4D4D4";
        };
        bright = {
          black = "0x808080";
          red = "0xD16969";
          green = "0xB5CEA8";
          yellow = "0xD7BA7D";
          blue = "0x9CDCFE";
          magenta = "0xC586C0";
          cyan = "0x4FC1FF";
          white = "0xFFFFFF";
        };
        selection = {
          text = "0xD4D4D4";
          background = "0x264F78";
        };
        search = {
          matches = {
            foreground = "0x1F1F1F";
            background = "0x613315";
          };
          focused_match = {
            foreground = "0x1F1F1F";
            background = "0x515C6A";
          };
        };
      };

      bell = {
        animation = "EaseOutExpo";
        duration = 0;
      };

      mouse = {
        hide_when_typing = false;
      };

      selection = {
        semantic_escape_chars = ",│`|:\"' ()[]{}<>";
      };

      cursor = {
        style = "Block";
        unfocused_hollow = true;
      };

      live_config_reload = true;
    };
  };
}
