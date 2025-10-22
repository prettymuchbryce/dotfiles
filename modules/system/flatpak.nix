{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Only enable flatpak on Linux systems
  config = lib.mkIf pkgs.stdenv.isLinux {

    services.flatpak = {
      enable = true;

      # Declaratively install Flatpak applications
      packages = [
        "org.signal.Signal"
        "com.slack.Slack"
        "com.spotify.Client"
        "org.telegram.desktop"
        "org.videolan.VLC"
        "com.discordapp.Discord"
        "org.keepassxc.KeePassXC"
      ];

      # Application-specific overrides for sandboxing permissions
      overrides = {

        # Communication apps with audio/video support
        "org.signal.Signal" = {
          Context.sockets = [
            "wayland"
            "fallback-x11"
            "pulseaudio"
          ];
        };

        "com.slack.Slack" = {
          Context.sockets = [
            "wayland"
            "fallback-x11"
            "pulseaudio"
          ];
        };

        "org.keepassxc.KeepPassXC" = {
          Context.sockets = [
            "wayland"
          ];
        };

        "com.discordapp.Discord" = {
          Context.sockets = [
            "wayland"
            "pulseaudio"
          ];

          Environment = {
            ELECTRON_OZONE_PLATFORM_HINT = "wayland";
          };
        };

        # Media apps requiring audio support
        "com.spotify.Client" = {
          Context.sockets = [
            "wayland"
            "fallback-x11"
            "pulseaudio"
          ];
        };

        "org.videolan.VLC" = {
          Context.sockets = [
            "wayland"
            "fallback-x11"
            "pulseaudio"
          ];
        };

        # Telegram with audio for voice messages
        "org.telegram.desktop" = {
          Context.sockets = [
            "wayland"
            "fallback-x11"
            "pulseaudio"
          ];
        };
      };
    };

    # Font configuration to ensure Flatpak apps have access to system fonts
    fonts.fontDir.enable = true;

    # Enable Flatpak session helper for proper desktop integration
    systemd.user.services.flatpak-session-helper = {
      enable = true;
      wantedBy = [ "default.target" ];
    };
  };
}
