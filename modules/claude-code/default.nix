{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Only enable on Linux systems
  config = lib.mkIf pkgs.stdenv.isLinux {
    home.packages = [ pkgs.claude-code ];
  };
}
