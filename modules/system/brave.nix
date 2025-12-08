{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    # Install Brave to /Applications/Nix Apps/
    environment.systemPackages = [ pkgs.brave ];

    # Custom shorcuts
    system.defaults.CustomUserPreferences = {
      "com.brave.Browser" = {
        "NSUserKeyEquivalents"."Select Previous Tab" = "@j";
        "NSUserKeyEquivalents"."Select Next Tab" = "@;";
      };
    };
  };
}
