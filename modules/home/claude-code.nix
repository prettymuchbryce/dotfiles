{
  config,
  lib,
  pkgs,
  ...
}:

let
  nodejsDrv = builtins.head (
    builtins.filter (drv: builtins.match "nodejs.*" drv.name != null) pkgs.claude-code.nativeBuildInputs
  );
  nodejs = nodejsDrv.out;
in
{
  config = {
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
        process = "${lib.getExe nodejs}";
        protocol = "tcp";
        port = 443;
        host = "(?i)^([a-zA-Z0-9-]+\\.)?claude\\.ai$";
      }
      {
        name = "Allow Claude Code → Anthropic";
        process = "${lib.getExe nodejs}";
        protocol = "tcp";
        port = 443;
        host = "(?i)^([a-zA-Z0-9-]+\\.)?anthropic\\.com$";
      }
      {
        name = "Allow Claude Code → npm registry";
        parentProcess = "${lib.getExe nodejs}";
        protocol = "tcp";
        port = 443;
        host = "(?i)^registry\\.npmjs\\.org$";
      }
      {
        name = "Allow Claude Code → Google";
        process = "${lib.getExe nodejs}";
        protocol = "tcp";
        port = 443;
        host = "www.google.com";
      }
      {
        name = "Allow Claude Code → GitHub";
        process = "${lib.getExe nodejs}";
        protocol = "tcp";
        port = 443;
        host = "raw.githubusercontent.com";
      }
    ];
  };
}
