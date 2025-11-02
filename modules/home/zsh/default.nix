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
    initContent = lib.mkOrder 550 ''
      ${builtins.readFile ./session_variables.zsh}
      ${builtins.readFile ./functions.zsh}
      ${builtins.readFile "${flakeRoot}/.secrets/env-vars.sh"}
    '';
  };

  # Add rust bin and local bin to path (platform-aware)
  home.sessionPath = [
    "$HOME/.cargo/bin"
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
    "/Users/bryce/.local/bin"
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    "/home/bryce/.local/bin"
  ];
}
