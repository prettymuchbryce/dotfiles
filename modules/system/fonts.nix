# Custom fonts module
{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Create a custom derivation for sfpro-nerd-font
  sfpro-nerd-font = pkgs.stdenv.mkDerivation {
    pname = "sfpro-nerd-font";
    version = "unstable-2024";

    src = pkgs.fetchFromGitHub {
      owner = "gstand";
      repo = "apple-nerd-fonts";
      rev = "73da727f860c88f3a2077d5cdff8d1d303e9f6b9";
      sha256 = "sha256-QN2XErzflJaFHZKWjOIq9TS8+4yOI/g+SyeGbc9fuSg=";
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/fonts/truetype
      cp -r sfpro-nerd-font/*.ttf $out/share/fonts/truetype/

      runHook postInstall
    '';

    meta = with lib; {
      description = "San Francisco Pro Nerd Font";
      homepage = "https://github.com/gstand/apple-nerd-fonts";
      license = licenses.unfree;
      platforms = platforms.all;
    };
  };
in
{
  # Font configuration
  fonts = {
    packages = with pkgs; [
      sfpro-nerd-font
      # Add other fonts here as needed
    ];
  };
}

