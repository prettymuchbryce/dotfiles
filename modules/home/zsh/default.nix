{
  pkgs,
  config,
  lib,
  flakeRoot,
  ...
}:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Better shell history
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  # Better ls
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file.".config/openaiapirc".source = "${flakeRoot}/.secrets/openaiapirc";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    defaultKeymap = "emacs";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = import ./aliases.nix;
    history.extended = true;

    siteFunctions._wt = builtins.readFile ./scripts/_wt;

    # Content for login shells only.
    # Runs before ~/.zshrc.
    profileExtra = ''
      setopt interactivecomments
      ${lib.optionalString pkgs.stdenv.isDarwin ''
        eval "$(/opt/homebrew/bin/brew shellenv)" # homebrew on macOS
      ''}
    '';

    # Modifies ~/.zshrc content for all zsh shells.
    # Add custom paths at the beginning so they're available in all interactive shells
    #
    # Scripts in scripts/ fall into two categories. In both cases we prefer to
    # reference them at their current location in this repository rather than
    # build them into nix, because changes take effect immediately (new terminal
    # for sourced scripts, instantly for PATH scripts) without a full system rebuild.
    #
    #   - Standalone executables (tabname, zellij-claude-status, mksh, etc.):
    #     Found via PATH. Run as subprocesses.
    #   - Sourced scripts (wt, functions.zsh):
    #     Must run in the current shell (e.g. wt uses cd to change directories).
    initContent = lib.mkOrder 550 ''
      # Add custom paths
      export PATH="$HOME/.cargo/bin:$PATH"
      export PATH="${config.home.homeDirectory}/.dotfiles/modules/home/zsh/scripts:$PATH"
      ${lib.optionalString pkgs.stdenv.isDarwin ''
        export PATH="/Users/bryce/.local/bin:$PATH"
      ''}
      ${lib.optionalString pkgs.stdenv.isLinux ''
        export PATH="/home/bryce/.local/bin:$PATH"
      ''}

      ${builtins.readFile ./session_variables.zsh}
      source "${config.home.homeDirectory}/.dotfiles/modules/home/zsh/functions.zsh"
      source "${config.home.homeDirectory}/.dotfiles/modules/home/zsh/scripts/wt"
      ${builtins.readFile "${flakeRoot}/.secrets/env-vars.sh"}
    '';
  };
}
