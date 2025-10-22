# Test file for OpenSnitch Simple Rule Generator
# This file tests the cmdLine functionality and other rule generation features
{ lib ? (import <nixpkgs> {}).lib }:

let
  simpleGen = import ./simple-gen.nix { inherit lib; };
  inherit (simpleGen) mkSimpleRule mkSimpleRules;

  # Test cases for cmdLine functionality
  testRules = [
    # Test cmdLine with regexp pattern
    {
      name = "Allow Python scripts with specific args";
      process = "/usr/bin/python3";
      cmdLine = "python3.*--enable-networking";
      protocol = "tcp";
    }

    # Test cmdLine combined with other conditions
    {
      name = "Allow curl with GitHub hosts";
      process = "/usr/bin/curl";
      cmdLine = "curl.*github\\.com";
      port = 443;
      protocol = "tcp";
    }

    # Test existing functionality still works
    {
      name = "Regular rule without cmdLine";
      process = "/usr/bin/ssh";
      host = "github.com";
      port = 22;
      protocol = "tcp";
    }

    # Test multiple conditions including cmdLine
    {
      name = "Complex rule with cmdLine";
      process = "/usr/bin/npm";
      cmdLine = "npm.*install";
      host = "registry\\.npmjs\\.org";
      port = 443;
      protocol = "tcp";
    }
  ];

  # Generate rules from test cases
  generatedRules = mkSimpleRules testRules;

  # Validation functions
  validateRule = ruleName: rule:
    let
      hasValidStructure = rule ? name && rule ? enabled && rule ? action && rule ? operator;
      hasCommandCondition =
        if rule.operator ? type && rule.operator.type == "list"
        then lib.any (cond: cond.operand or null == "process.command") rule.operator.list
        else rule.operator.operand or null == "process.command";
    in {
      inherit ruleName;
      valid = hasValidStructure;
      hasCommandCondition = hasCommandCondition;
    };

  # Run validation on generated rules
  validations = lib.mapAttrsToList validateRule generatedRules;

in
{
  inherit generatedRules testRules validations;

  # Summary of test results
  summary = {
    totalRules = lib.length testRules;
    generatedKeys = lib.attrNames generatedRules;
    rulesWithCmdLine = lib.length (lib.filter (rule: rule ? cmdLine) testRules);
    validRules = lib.length (lib.filter (v: v.valid) validations);
    rulesWithCommandCondition = lib.length (lib.filter (v: v.hasCommandCondition) validations);
  };
}