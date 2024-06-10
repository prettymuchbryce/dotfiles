{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awslogs
    git-crypt

    # Better alternatives
    ripgrep # grep

    # Structured data
    jq
  ];

  programs.starship = {
    enable = true;
  };
}
