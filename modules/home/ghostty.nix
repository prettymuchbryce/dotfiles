{
  config,
  lib,
  pkgs,
  ...
}:

let
  ghosttyConfig = ''
    # Shell configuration
    command = ${pkgs.zsh}/bin/zsh --login -c "${pkgs.zellij}/bin/zellij attach -c main"
    term = xterm-256color

    # Window configuration
    window-width = 2160
    window-height = 1440
    window-padding-x = 0
    window-padding-y = 0
    window-decoration = none
    macos-option-as-alt = true

    # Scrollback configuration
    scrollback-limit = 100000
    mouse-scroll-multiplier = 3

    # Font configuration
    font-family = FiraCode Nerd Font Mono
    font-style-bold = Bold
    font-style-italic = Italic
    font-size = 16
    font-thicken = true
    font-thicken-strength = 1

    # Updates
    auto-update = check

    # Color configuration
    background = 1F1F1F
    foreground = D4D4D4

    # Cursor configuration
    cursor-style=block
    cursor-color=#9cdcfe
    cursor-text=#000000

    # Normal colors (palette indices 0-7)
    palette = 0=808080
    palette = 1=F44747
    palette = 2=6A9955
    palette = 3=DCDCAA
    palette = 4=569CD6
    palette = 5=C586C0
    palette = 6=4EC9B0
    palette = 7=D4D4D4

    # Bright colors (palette indices 8-15)
    palette = 8=808080
    palette = 9=D16969
    palette = 10=B5CEA8
    palette = 11=D7BA7D
    palette = 12=9CDCFE
    palette = 13=C586C0
    palette = 14=4FC1FF
    palette = 15=FFFFFF

    # Selection colors
    selection-foreground = D4D4D4
    selection-background = 264F78

    # Mouse configuration
    mouse-hide-while-typing = false

    # Ensure configuration reloads work
    confirm-close-surface = true

    # Mac-style copy/paste shortcuts in terminal
    keybind = super+c=copy_to_clipboard
    keybind = super+v=paste_from_clipboard
  '';
in
{
  home.file.".config/ghostty/config".text = ghosttyConfig;
}
