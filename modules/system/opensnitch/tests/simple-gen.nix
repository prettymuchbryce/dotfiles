# Test examples for the OpenSnitch rule conversion logic
{ lib, pkgs }:

let
  simpleGen = import ../simple-gen.nix { inherit lib; };
  inherit (simpleGen) mkSimpleRule mkSimpleRules;

  # Test cases covering different rule types from your existing configuration

  # Simple rule - just process and port
  simpleRule = mkSimpleRule {
    name = "Allow Syncthing TCP sync";
    process = "${lib.getBin pkgs.syncthing}/bin/syncthing";
    port = 22000;
    protocol = "tcp";
  };

  # Network rule with LAN restriction
  networkRule = mkSimpleRule {
    name = "Allow Syncthing data (LAN)";
    process = "${lib.getBin pkgs.syncthing}/bin/syncthing";
    port = 22000;
    network = "LAN";
  };

  # Regex process rule (like your nix binary rule)
  regexProcessRule = mkSimpleRule {
    name = "Allow Nix GitHub/NixOS access";
    process = "^.*/bin/nix$";
    host = "^(([a-z0-9|-]+\\.)*github\\.com|([a-z0-9|-]+\\.)*nixos\\.org)$";
    port = 443;
    protocol = "tcp";
  };

  # Host regex rule (like your clamav rule)
  hostRegexRule = mkSimpleRule {
    name = "Allow ClamAV updates";
    process = "${lib.getBin pkgs.clamav}/bin/freshclam";
    host = "^([a-z0-9|-]+\\.)*clamav\\.net$";
  };

  # IP regex rule (like your DNS rules)
  ipRegexRule = mkSimpleRule {
    name = "Allow dnscrypt Mullvad DoH";
    process = "${lib.getBin pkgs.dnscrypt-proxy2}/bin/dnscrypt-proxy";
    ip = "^(194\\.242\\.2\\.4|2a07:e340::4)$";
    port = 443;
    protocol = "tcp";
  };

  # Parent process rule (like your Claude Code rule)
  parentProcessRule = mkSimpleRule {
    name = "Allow Claude Code subprocess";
    parentProcess = "/nix/store/*-claude-code-*/bin/claude-code";
    host = "api.anthropic.com";
    port = 443;
    protocol = "tcp";
  };

  # Single condition rule (like your localhost rule)
  singleConditionRule = mkSimpleRule {
    name = "Allow localhost connections";
    ip = "^(127\\.0\\.0\\.1|::1)$";
  };

  # Multiple rules at once
  multipleRules = mkSimpleRules [
    {
      name = "Rule One";
      process = "/usr/bin/test1";
      port = 8080;
    }
    {
      name = "Rule Two";
      process = "/usr/bin/test2";
      host = "example.com";
    }
  ];

in
{
  # Export all test cases for inspection
  inherit simpleRule networkRule regexProcessRule hostRegexRule
          ipRegexRule parentProcessRule singleConditionRule multipleRules;

  # Combined ruleset for testing
  testRules = lib.mkMerge [
    simpleRule
    networkRule
    regexProcessRule
    hostRegexRule
    ipRegexRule
    parentProcessRule
    singleConditionRule
    multipleRules
  ];
}