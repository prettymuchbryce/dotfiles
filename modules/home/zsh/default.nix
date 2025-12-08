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
      ${builtins.readFile ./functions.zsh}
      ${builtins.readFile "${flakeRoot}/.secrets/env-vars.sh"}
    '';
  };
}
