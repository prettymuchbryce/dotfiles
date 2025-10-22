{
  config,
  lib,
  pkgs,
  ...
}:


{
  services.dnscrypt-proxy = {
    enable = true;
    settings = {
      listen_addresses = [
        "127.0.0.1:53" # IPv4
        "[::1]:53" # IPv6
      ];

      # Only use DoH (not DNSCrypt)
      doh_servers = true;
      dnscrypt_servers = false;

      cache = true;
      cache_size = 4096;

      require_dnssec = true; # strictness over availability
      require_nolog = false;
      require_nofilter = false;

      # Where to do the initial bootstrap resolve (for DoH endpoints)
      # These are only used to resolve Mullvad’s hostnames.
      bootstrap_resolvers = [
        "9.9.9.9:53"
        "1.1.1.1:53"
        "8.8.8.8:53"
      ];

      # kill resolver/relay auto-updates
      sources = { };
      ignore_system_dns = true;

      # Choose the Mullvad profile you want to use here
      server_names = [ "mullvad-base-doh" ];

      static = {
        # To inspect stamp use: https://dnscrypt.info/stamps/
        "mullvad-base-doh".stamp =
          "sdns://AgcAAAAAAAAACzE5NC4yNDIuMi40ABRiYXNlLmRucy5tdWxsdmFkLm5ldAovZG5zLXF1ZXJ5";
      };
      # -------------------------------------------------------------------------

      # Optional: log queries while testing (then disable)
      # query_log.file = "/var/log/dnscrypt-proxy/queries.log";
    };
  };

  #### Point the system at the local stub & keep NM from editing resolv.conf
  networking = {
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
    resolvconf.enable = true;
    resolvconf.useLocalResolver = true;

    networkmanager.dns = "none"; # Don’t let NM push DNS
  };

  # Allow loopback DNS
  networking.firewall.allowedTCPPorts = lib.mkAfter [ 53 ];
  networking.firewall.allowedUDPPorts = lib.mkAfter [ 53 ];

  opensnitchRules = [
    {
      name = "Allow dnscrypt-proxy → Mullvad base DoH (host)";
      process = "${lib.getBin pkgs.dnscrypt-proxy}/bin/dnscrypt-proxy";
      port = 443;
      protocol = "tcp";
      host = "(?i)^base\\.dns\\.mullvad\\.net$";
    }
    {
      name = "Allow dnscrypt-proxy → Mullvad base DoH (IP)";
      process = "${lib.getBin pkgs.dnscrypt-proxy}/bin/dnscrypt-proxy";
      port = 443;
      protocol = "tcp";
      ip = "^(194\\.242\\.2\\.4|2a07:e340::4)$";
    }
    {
      name = "Allow dnscrypt-proxy → bootstrap resolvers (UDP 53)";
      process = "${lib.getBin pkgs.dnscrypt-proxy}/bin/dnscrypt-proxy";
      port = 53;
      protocol = "udp";
      ip = "^(9\\.9\\.9\\.9|1\\.1\\.1\\.1|8\\.8\\.8\\.8)$";
    }
  ];
}
