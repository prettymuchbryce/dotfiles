# Wofi configuration for application launching

{ lib, pkgs, ... }:

{
  config = lib.mkIf pkgs.stdenv.isLinux {
    programs.wofi = {
      enable = true;
      settings = {
        width = 600;
        height = 400;
        location = "center";
        show = "drun";
        prompt = "Applications";
        filter_rate = 100;
        allow_markup = true;
        no_actions = true;
        halign = "fill";
        orientation = "vertical";
        content_halign = "fill";
        insensitive = true;
        allow_images = true;
        image_size = 40;
        gtk_dark = true;
      };

      # VS Code inspired dark theme
      style = ''
        window {
          margin: 0px;
          border: 2px solid #569cd6;
          background-color: #1e1e1e;
          border-radius: 6px;
        }

        #input {
          all: unset;
          min-height: 36px;
          padding: 4px 10px;
          margin: 4px;
          border: none;
          color: #d4d4d4;
          font-weight: bold;
          background-color: #2d2d30;
          border-radius: 3px;
        }

        #input:focus {
          border: 2px solid #569cd6;
        }

        #inner-box {
          margin: 4px;
          border: none;
          background-color: #1e1e1e;
        }

        #outer-box {
          margin: 0px;
          border: none;
          background-color: #1e1e1e;
        }

        #scroll {
          margin: 0px;
          border: none;
        }

        #text {
          margin: 5px;
          border: none;
          color: #d4d4d4;
        }

        #entry {
          margin: 0px;
          border: none;
          border-radius: 3px;
          background-color: transparent;
        }

        #entry:selected {
          background-color: #569cd6;
        }

        #entry:selected #text {
          color: #1e1e1e;
          font-weight: bold;
        }

        #text:selected {
          color: #1e1e1e;
          font-weight: bold;
        }
      '';
    };
  };
}