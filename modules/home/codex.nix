{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.codex = {
    enable = true;
  };

  opensnitchRules = [
    {
      name = "Allow Codex → OpenAI API";
      process = "${lib.getExe pkgs.codex}";
      protocol = "tcp";
      port = 443;
      host = "(?i)^api\\.openai\\.com$";
    }
    {
      name = "Allow Codex (login) → ChatGPT";
      process = "${lib.getExe pkgs.codex}";
      protocol = "tcp";
      port = 443;
      host = "(?i)^([a-z0-9-]+\\.)?chatgpt\\.com$";
    }
    {
      name = "Allow Codex (login) → OpenAI Auth";
      process = "${lib.getExe pkgs.codex}";
      protocol = "tcp";
      port = 443;
      host = "(?i)^([a-z0-9-]+\\.)?openai\\.com$";
    }
    # {
    #   name = "Allow Codex (npm update) → npm registry";
    #   parentProcess = "${lib.getExe pkgs.codex.nodejs}";
    #   protocol = "tcp";
    #   port = 443;
    #   host = "(?i)^registry\\.npmjs\\.org$";
    # }
    {
      name = "Allow Codex (version check) → GitHub API";
      process = "${lib.getExe pkgs.codex}";
      protocol = "tcp";
      port = 443;
      host = "(?i)^api\\.github\\.com$";
    }
  ];

  persistenceDirectories = [
    ".codex"
  ];
}
