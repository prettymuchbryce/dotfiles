{ lib, pkgs, ... }:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    # ovim - popup editor for text fields
    homebrew.casks = [
      "tonisives/tap/ovim"
    ];
  };
}
