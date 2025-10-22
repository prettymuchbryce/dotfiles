{
  config,
  pkgs,
  lib,
  ...
}:
let
  format = pkgs.formats.json { };
  hmUsers = config.home-manager.users or { };

  # Import simple rule generator
  simpleGen = import ./simple-gen.nix { inherit lib; };
  inherit (simpleGen) mkSimpleRules;

  # Import system rules as simple rules too
  systemSimpleRules = import ./system-rules.nix { inherit pkgs lib; };

  # Convert simple rules from all sources
  allSimpleRules = lib.flatten [
    systemSimpleRules
    (config.opensnitchRules or [ ])
    (lib.concatMap (u: u.opensnitchRules or [ ]) (lib.attrValues hmUsers))
  ];

  convertedSimpleRules = if allSimpleRules != [ ] then mkSimpleRules allSimpleRules else { };

  # Network aliases for LAN and MULTICAST shortcuts
  networkAliases = {
    LAN = [
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
      "127.0.0.0/8"
      "::1"
      "fc00::/7"
    ];
    LOCALHOST = [
      "127.0.0.0/8"
      "::1"
    ];
    LINKLOCALv6 = [ "fe80::/10" ];
    MULTICAST = [
      "224.0.0.0/4"
      "ff00::/8"
    ];
  };
in
{
  # Add system-wide option for simple rules (matching home manager naming)
  options.opensnitchRules = lib.mkOption {
    type = lib.types.listOf (lib.types.attrsOf lib.types.anything);
    default = [ ];
    description = "Simple OpenSnitch rules that will be converted to verbose format automatically";
    example = [
      {
        name = "Allow SSH to GitHub";
        process = "/usr/bin/ssh";
        port = 22;
        host = "github.com";
        protocol = "tcp";
      }
    ];
  };

  config = {
    environment.systemPackages = [
      pkgs.opensnitch-ui
    ];

    systemd.user.services.opensnitch-ui = {
      description = "OpenSnitch UI (after Waybar, Hyprland)";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [
        "graphical-session.target"
        "waybar.service"
      ];
      wants = [ "waybar.service" ];

      serviceConfig = {
        ExecStart = "${pkgs.opensnitch-ui}/bin/opensnitch-ui --background";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

    # OpenSnitch firewall service configuration
    services.opensnitch = {
      enable = true;
      settings.DefaultAction = "deny";
      rules = convertedSimpleRules;
    };

    # Create network_aliases.json file for LAN and MULTICAST shortcuts
    environment.etc."opensnitchd/network_aliases.json" = {
      text = builtins.toJSON networkAliases;
      mode = "0644";
    };
  };
}
