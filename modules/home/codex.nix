{
  config,
  flakeInputs,
  lib,
  pkgs,
  ...
}:
let
  codexPkg = flakeInputs.codex-cli-nix.packages.${pkgs.stdenv.system}.default;
in
{
  programs.codex = {
    enable = true;
    package = codexPkg;
  };

  opensnitchRules = [
    {
      name = "Allow Codex → OpenAI API";
      process = "${lib.getExe codexPkg}";
      protocol = "tcp";
      port = 443;
      host = "(?i)^api\\.openai\\.com$";
    }
    {
      name = "Allow Codex (login) → ChatGPT";
      process = "${lib.getExe codexPkg}";
      protocol = "tcp";
      port = 443;
      host = "(?i)^([a-z0-9-]+\\.)?chatgpt\\.com$";
    }
    {
      name = "Allow Codex (login) → OpenAI Auth";
      process = "${lib.getExe codexPkg}";
      protocol = "tcp";
      port = 443;
      host = "(?i)^([a-z0-9-]+\\.)?openai\\.com$";
    }
    # {
    #   name = "Allow Codex (npm update) → npm registry";
    #   parentProcess = "${lib.getExe codexPkg.nodejs}";
    #   protocol = "tcp";
    #   port = 443;
    #   host = "(?i)^registry\\.npmjs\\.org$";
    # }
    {
      name = "Allow Codex (version check) → GitHub API";
      process = "${lib.getExe codexPkg}";
      protocol = "tcp";
      port = 443;
      host = "(?i)^api\\.github\\.com$";
    }
  ];

  persistenceDirectories = [
    ".codex"
  ];
}
