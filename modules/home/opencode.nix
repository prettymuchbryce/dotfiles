{
  flakeInputs,
  hostname,
  lib,
  pkgs,
  ...
}:
let
  isMacMini = hostname == "Bryces-Mac-mini";
  opencodePkg = flakeInputs.opencode.packages.${pkgs.stdenv.system}.default;
  ollamaBaseUrl = if isMacMini then "http://127.0.0.1:11434/v1" else "http://bryces-mac-mini:11434/v1";
  opencodeConfig = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    autoupdate = false;
    model = "ollama/sinhang/qwen3.5-claude-4.6-opus:27b-q4_K_M";
    small_model = "ollama/sinhang/qwen3.5-claude-4.6-opus:27b-q4_K_M";
    provider = {
      ollama = {
        npm = "@ai-sdk/openai-compatible";
        name = "Ollama (local)";
        options = {
          baseURL = ollamaBaseUrl;
        };
        models = {
          "sinhang/qwen3.5-claude-4.6-opus:27b-q4_K_M" = {
            name = "Qwen3.5 27B Claude 4.6 Opus Distilled";
            reasoning = true;
            tool_call = true;
          };
        };
      };
    };
  };
in
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = [ opencodePkg ];

    home.file.".config/opencode/opencode.json".text = opencodeConfig;

    persistenceDirectories = [ ".config/opencode" ];
  };
}
