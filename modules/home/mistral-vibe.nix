{ lib, pkgs, mistral-vibe, ... }:

{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = [
      # Wrap to only expose the vibe CLI, avoiding Python binary conflicts
      (pkgs.runCommand "mistral-vibe-wrapped" { } ''
        mkdir -p $out/bin
        ln -s ${mistral-vibe}/bin/vibe $out/bin/vibe
      '')
    ];
  };
}
