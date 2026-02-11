{
  pkgs,
  lib,
  ...
}:

lib.mkIf pkgs.stdenv.isDarwin {
  services.autotidy.enable = true;

  home.file.".config/autotidy/config.yaml".source = ./config.yaml;
}
