{ pkgs, lib }:

# System rules - just return simple rule array, conversion happens automatically
[
  {
    name = "Allow all localhost";
    ip = "^(127\\.0\\.0\\.1|::1)$";
  }
  {
    name = "Allow NTP";
    process = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-timesyncd";
    port = 123;
    protocol = "udp";
  }
  {
    name = "Allow Nix";
    process = "${lib.getBin pkgs.nix}/bin/nix";
    host = "^(([a-z0-9|-]+\\.)*github\\.com|([a-z0-9|-]+\\.)*nixos\\.org)$";
  }
  {
    name = "Allow Nix Cache";
    process = "${lib.getBin pkgs.nix}/bin/nix";
    port = 443;
    host = "(cache\\.nixos\\.org|nix-community\\.cachix\\.org)";
  }
  {
    name = "Allow NetworkManager DHCP (LAN only)";
    process = "${lib.getBin pkgs.networkmanager}/bin/NetworkManager";
    port = 67;
    protocol = "udp";
    network = "LAN";
  }
  {
    name = "Allow SSH to GitHub";
    process = "${lib.getBin pkgs.openssh}/bin/ssh";
    port = 22;
    host = "github.com";
    protocol = "tcp";
  }
]
