{ pkgs, config, lib, ... }:
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

  home.file."zsh/plugins".source = ./plugins;
  home.file.".config/openaiapirc".source = ../../.secrets/openaiapirc;
  home.file."scripts/query-staked.sh".source = ../../.secrets/query-staked.sh;

  home.file.".config/hosts/hosts.focus".source = ./hosts/hosts.focus;
  home.file.".config/hosts/hosts.unfocus".source = ./hosts/hosts.unfocus;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    defaultKeymap = "viins";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = import ./aliases.nix;
    history.extended = true;

    profileExtra = ''
      setopt interactivecomments
      ${lib.optionalString pkgs.stdenv.isDarwin ''
        eval "$(/opt/homebrew/bin/brew shellenv)" # homebrew on macOS
      ''}
    '';

    initExtraBeforeCompInit = ''
      ${builtins.readFile ./session_variables.zsh}
      ${builtins.readFile ./functions.zsh}
      ${builtins.readFile ../../.secrets/env-vars.sh}
      # zsh_codex
      ${builtins.readFile ./plugins/zsh_codex/zsh_codex.plugin.zsh}
      bindkey '^O' create_completion
    '';
  };

  # Add rust bin and local bin to path (platform-aware)
  home.sessionPath = [
    "$HOME/.cargo/bin"
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    "/Users/bryce/.local/bin"
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    "/home/bryce/.local/bin"
  ];
}
