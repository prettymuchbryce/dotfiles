{
  config,
  flakeRoot,
  lib,
  pkgs,
  ...
}:

let
  claudeExe = lib.getExe pkgs.claude-code;
in
{
  config = {
    home.file.".claude/CLAUDE.md".source = "${flakeRoot}/.secrets/CLAUDE.md";

    home.file.".claude/settings.json".text = builtins.toJSON {
      voiceEnabled = true;
      permissions = {
        deny = [
          "Read(**/.secrets/**)"
          "Bash(cat */.secrets/*)"
          "Bash(less */.secrets/*)"
          "Bash(head */.secrets/*)"
          "Bash(tail */.secrets/*)"
          "Bash(*/.secrets/*)"
        ];
      };
      hooks = {
        SessionStart = [
          {
            hooks = [
              {
                type = "command";
                command = "zellij-claude-status 🟢";
              }
            ];
          }
        ];
        UserPromptSubmit = [
          {
            hooks = [
              {
                type = "command";
                command = "zellij-claude-status 🔴";
              }
            ];
          }
        ];
        PostToolUse = [
          {
            hooks = [
              {
                type = "command";
                command = "zellij-claude-status 🔴";
              }
            ];
          }
        ];
        Notification = [
          {
            matcher = "permission_prompt";
            hooks = [
              {
                type = "command";
                command = "zellij-claude-status 🔴";
              }
            ];
          }
        ];
        Stop = [
          {
            hooks = [
              {
                type = "command";
                command = "zellij-claude-status 🟢";
              }
            ];
          }
        ];
      };
    };

    home.packages = [
      (pkgs.writeShellScriptBin "claude" ''
        export DISABLE_ERROR_REPORTING=1
        export DISABLE_TELEMETRY=1
        exec ${pkgs.claude-code}/bin/claude "$@"
      '')
    ];

    opensnitchRules = [
      {
        name = "Allow Claude Code → Claude AI";
        process = claudeExe;
        protocol = "tcp";
        port = 443;
        host = "(?i)^([a-zA-Z0-9-]+\\.)?claude\\.ai$";
      }
      {
        name = "Allow Claude Code → Anthropic";
        process = claudeExe;
        protocol = "tcp";
        port = 443;
        host = "(?i)^([a-zA-Z0-9-]+\\.)?anthropic\\.com$";
      }
      {
        name = "Allow Claude Code → npm registry";
        parentProcess = claudeExe;
        protocol = "tcp";
        port = 443;
        host = "(?i)^registry\\.npmjs\\.org$";
      }
      {
        name = "Allow Claude Code → Google";
        process = claudeExe;
        protocol = "tcp";
        port = 443;
        host = "www.google.com";
      }
      {
        name = "Allow Claude Code → GitHub";
        process = claudeExe;
        protocol = "tcp";
        port = 443;
        host = "raw.githubusercontent.com";
      }
    ];
  };
}
