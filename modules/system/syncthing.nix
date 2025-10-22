{
  config,
  pkgs,
  lib,
  flakeRoot,
  ...
}:

{
  services.syncthing = {
    enable = true;
    user = "bryce";
    dataDir = "/home/bryce/.syncthing";
    configDir = "/home/bryce/.config/syncthing";

    # Local network only settings
    settings = {
      # Device settings
      devices = {
        "remote-machine" = {
          id = lib.strings.removeSuffix "\n" (
            builtins.readFile "${flakeRoot}/.secrets/mac-syncthing-device-id"
          );
          addresses = [
            "dynamic"
          ];
        };
      };

      # Folder settings
      folders = {
        "notes" = {
          id = "xm692-wyeuw";
          path = "/home/bryce/notes"; # Directory to sync
          devices = [ "remote-machine" ];
          # Local network only, no global discovery
          ignorePerms = false;
          # Don't use versioning by default
          versioning = null;
        };
        "linux-kbdx" = {
          id = "vried-smmdn";
          path = "/home/bryce/linux-kbdx"; # Directory to sync
          devices = [ "remote-machine" ];
          # Local network only, no global discovery
          ignorePerms = false;
          # Don't use versioning by default
          versioning = null;
        };
      };

      # Global options - restrict to local network only
      options = {
        # Disable global discovery and relaying
        globalAnnounceEnabled = false;
        localAnnounceEnabled = true;
        relaysEnabled = false;
        natEnabled = false;
        # Only listen on local interfaces
        listenAddresses = [
          "tcp://0.0.0.0:22000"
          "quic://0.0.0.0:22000"
        ];
        # Disable usage reporting
        urAccepted = -1;
        # Disable crash reporting
        crashReportingEnabled = false;
        # Disable automatic updates
        autoUpgradeIntervalH = 0;
        # Set custom announce servers to empty (local only)
        globalAnnounceServers = [ ];
        # Disable default folder
        defaultFolderPath = "";
      };

      # GUI settings - restrict to localhost only
      gui = {
        enabled = true;
        address = "127.0.0.1:8384";
        # Disable authentication for localhost (change if needed)
        user = "";
        password = "";
        # Disable HTTPS for local access (change if needed)
        tls = false;
      };
    };

    # Override configuration to ensure local network only
    overrideDevices = true;
    overrideFolders = true;
  };

  # Ensure syncthing starts after network is ready
  systemd.services.syncthing.after = [ "network-online.target" ];
  systemd.services.syncthing.wants = [ "network-online.target" ];

  # OpenSnitch rules for Syncthing
  opensnitchRules = [
    {
      name = "Syncthing data 22000 (LAN)";
      process = "${lib.getBin pkgs.syncthing}/bin/syncthing";
      port = 22000;
      network = "LAN";
    }
    {
      name = "Syncthing data 22000 (IPv6 link-local)";
      process = "${lib.getBin pkgs.syncthing}/bin/syncthing";
      port = 22000;
      network = "LINKLOCALv6";
    }
    {
      name = "Syncthing discovery 21027 (multicast)";
      process = "${lib.getBin pkgs.syncthing}/bin/syncthing";
      port = 21027;
      network = "MULTICAST";
    }
    {
      name = "Syncthing discovery 21027 (LAN)";
      process = "${lib.getBin pkgs.syncthing}/bin/syncthing";
      port = 21027;
      network = "LAN";
    }
  ];

  persistenceUsers.bryce = {
    directories = [
      ".syncthing"
      ".config/syncthing"
      "notes"
      "linux-kbdx"
    ];
  };
}
