{ pkgs, ... }:
{
  programs.go = {
    enable = true;
    package = pkgs.go;
  };

  home.packages = with pkgs; [
    gotools # provides goimports
    gopls # Go language server
  ];
}
