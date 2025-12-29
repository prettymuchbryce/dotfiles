{ pkgs, lib, ... }:
{
  # Alacritty terminal - used by ovim for popup editing
  programs.alacritty = {
    enable = true;
  };

  # ovim terminal launcher configuration (macOS only)
  home.file."Library/Application Support/ovim/terminal-launcher.sh" = lib.mkIf pkgs.stdenv.isDarwin {
    executable = true;
    text = ''
      #!/bin/zsh -l
      # ovim terminal launcher script
      # Runs as a login shell to inherit full PATH from .zprofile
      # Also source .zshrc for additional PATH entries (fnm/node, cargo, etc.)
      source ~/.zshrc

      export NVIM_OVIM=1  # Minimal UI for ovim popups

      # Signal that we're handling the terminal spawn ourselves
      "$OVIM_CLI" launcher-handled --session "$OVIM_SESSION_ID"

      # Convert pixel dimensions to approximate character dimensions
      # Assuming ~9px per character width and ~18px per line height
      COLS=$((OVIM_WIDTH / 9))
      LINES=$((OVIM_HEIGHT / 18))

      # Launch Alacritty with neovim at the specified position
      alacritty \
        --option "window.dimensions.columns=$COLS" \
        --option "window.dimensions.lines=$LINES" \
        --option 'window.decorations="None"' \
        --option "font.size=16" \
        -e $OVIM_EDITOR --listen "$OVIM_SOCKET" "$OVIM_FILE"
    '';
  };
}
