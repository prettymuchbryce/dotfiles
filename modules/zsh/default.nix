{ pkgs, config, ... }:
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

  home.file."scripts/wd".source = ./scripts/wd;
  home.file."scripts/query-staked.sh".source = ../../.secrets/query-staked.sh;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    defaultKeymap = "viins";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = import ./aliases.nix;
    history.extended = true;

    initExtraBeforeCompInit = ''
      ${builtins.readFile ./session_variables.zsh}
      ${builtins.readFile ./functions.zsh}
      ${builtins.readFile ../../.secrets/env-vars.sh}
    '';
  };

  # Add rust bin to path
  home.sessionPath = [ "$HOME/.cargo/bin" ];
}
