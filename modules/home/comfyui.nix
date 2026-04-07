{
  flakeInputs,
  lib,
  pkgs,
  ...
}:
let
  comfyuiPkg = flakeInputs.comfyui-nix.packages.${pkgs.stdenv.system}.default;
in
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = [ comfyuiPkg ];
  };
}
