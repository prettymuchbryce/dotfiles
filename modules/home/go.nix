{ pkgs, ... }:
{
  programs.go = {
    enable = true;
    package = pkgs.go_1_24;
  };

  home.packages = with pkgs; [
    gotools # provides goimports
    gopls # Go language server
  ];
}
