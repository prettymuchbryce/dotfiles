{ pkgs, lib, ... }:
let
  notifyAllUsers = pkgs.writeShellScript "notify-all-users-of-av-finding" ''
    # clamd sets these env vars
    ALERT="Signature detected by clamav: $CLAM_VIRUSEVENT_VIRUSNAME in $CLAM_VIRUSEVENT_FILENAME"
    for ADDRESS in /run/user/*; do
      USERID="''${ADDRESS#/run/user/}"
      /run/wrappers/bin/sudo -u "#$USERID" \
        DBUS_SESSION_BUS_ADDRESS="unix:path=$ADDRESS/bus" \
        ${pkgs.libnotify}/bin/notify-send -i dialog-warning "Antivirus Finding" "$ALERT"
    done
  '';
in
{
  environment.systemPackages = with pkgs; [
    libnotify
    lynis
    aide
  ];

  services.clamav = {
    updater.enable = true; # freshclam timer
    daemon = {
      enable = true;
      settings = {
        VirusEvent = "${notifyAllUsers}";
        ExcludePath = [
          "^/nix/store($|/)"
          "^/(proc|sys|dev|run)($|/)"
        ];
      };
    };
  };

  # Safer sudoers: allow notify-send as any non-root user
  security.sudo.extraConfig = ''
    clamav ALL=(ALL,!root) NOPASSWD: SETENV: ${pkgs.libnotify}/bin/notify-send
  '';

  # Create a log dir and rotate it so results persist
  systemd.tmpfiles.rules = [
    "d /var/log/clamav 0750 root root -"
  ];
  services.logrotate = {
    enable = true;
    settings."/var/log/clamav/scan.log" = {
      rotate = 8;
      frequency = "weekly";
      compress = true;
      missingok = true;
      notifempty = true;
      create = "0640 root root";
    };
  };

  # Daily scan with jitter and excludes, polite scheduling and file logging
  systemd.services.av-all-scan.serviceConfig.ExecStart = ''
    ${pkgs.coreutils}/bin/nice -n 19 ${pkgs.util-linux}/bin/ionice -c2 -n7 \
    ${pkgs.clamav}/bin/clamdscan --infected --log=/var/log/clamav/scan.log \
      --fdpass --multiscan /
  '';

  systemd.timers.av-all-scan = {
    description = "Daily AV scan";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = "45m";
      Unit = "av-all-scan.service";
    };
  };

  opensnitchRules = [
    {
      name = "Allow clamav to update signatures";
      process = "${lib.getBin pkgs.clamav}/bin/freshclam";
      host = "^([a-z0-9|-]+\\.)*clamav\\.net$";
    }
  ];
}
