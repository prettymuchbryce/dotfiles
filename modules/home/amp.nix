{
  config,
  lib,
  pkgs,
  ...
}:

let
  # set manually for now
  # format = pkgs.formats.json { };
  # permissions = [
  # {
  # tool = "Read";
  # matches = {
  # path = "*/.secrets/*";
  # };
  # action = "reject";
  # }
  # ];
in
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = [ pkgs.amp-cli ];
  };
}
