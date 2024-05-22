{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    keyMode = "vi";
    baseIndex = 1;
    clock24 = true;
    secureSocket = false;
    customPaneNavigationAndResize = true;
    escapeTime = 0;
    tmuxinator.enable = true;
    historyLimit = 30000;
    extraConfig = ''
      # Default termtype. If the rcfile sets $TERM, that overrides this value.
      set -g terminal-overrides ',xterm-256color:Tc'

      # Unbind the default prefix
      unbind C-b

      # Bind Shift+Option+Control+b to act as the tmux prefix
      bind-key C-M-b send-prefix

      # Also use mouse
      setw -g mouse on

      # Remap jkl; to hjkl in copy mode
      bind -T copy-mode-vi j send-keys -X cursor-left
      bind -T copy-mode-vi k send-keys -X cursor-down
      bind -T copy-mode-vi l send-keys -X cursor-up
      bind -T copy-mode-vi ';' send-keys -X cursor-right

      # Remap jkl; to hjkl for pane resizing
      bind j resize-pane -L 5
      bind k resize-pane -D 5
      bind l resize-pane -U 5
      bind ';' resize-pane -R 5

      # Optional: Remap jkl; to hjkl for pane navigation (if you want to use C-b + j/k/l/; for navigation)
      bind j select-pane -L
      bind k select-pane -D
      bind l select-pane -U
      bind ';' select-pane -R
    '';

    plugins = with pkgs; [
      tmuxPlugins.jump
      tmuxPlugins.sensible
      tmuxPlugins.extrakto
      tmuxPlugins.tmux-fzf
      tmuxPlugins.open
      (callPackage ./tmux-colortag.nix { })
    ];
  };

  # Tmux configs
  home.file.".config/tmuxinator" = {
    source = ./tmuxinator;
    recursive = true;
  };
}
