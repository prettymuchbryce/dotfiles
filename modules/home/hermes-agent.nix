{
  flakeInputs,
  hostname,
  lib,
  pkgs,
  ...
}:
let
  isMacMini = hostname == "Bryces-Mac-mini";
  hermesSource = flakeInputs.hermes-agent.outPath;
  hermesInputs = flakeInputs.hermes-agent.inputs;
  hermesPkg =
    if pkgs.stdenv.isDarwin then
      let
        workspace = hermesInputs.uv2nix.lib.workspace.loadWorkspace { workspaceRoot = hermesSource; };
        overlay = workspace.mkPyprojectOverlay {
          sourcePreference = "wheel";
        };
        pythonSet =
          (pkgs.callPackage hermesInputs.pyproject-nix.build.packages {
            python = pkgs.python311;
          }).overrideScope
            (lib.composeManyExtensions [
              hermesInputs.pyproject-build-systems.overlays.default
              overlay
            ]);
        # Upstream uses the "all" extra, which pulls voice/STT dependencies
        # like onnxruntime that do not package cleanly on Darwin.
        hermesVenv = pythonSet.mkVirtualEnv "hermes-agent-env" {
          hermes-agent = [ "cli" "mcp" "acp" "pty" ];
        };
        bundledSkills = pkgs.lib.cleanSourceWith {
          src = "${hermesSource}/skills";
          filter = path: _type:
            !(pkgs.lib.hasInfix "/index-cache/" path);
        };
        runtimeDeps = with pkgs; [
          nodejs_20
          ripgrep
          git
          openssh
          ffmpeg
        ];
        runtimePath = pkgs.lib.makeBinPath runtimeDeps;
      in
      pkgs.stdenv.mkDerivation {
        pname = "hermes-agent";
        version = "0.1.0";

        dontUnpack = true;
        dontBuild = true;
        nativeBuildInputs = [ pkgs.makeWrapper ];

        installPhase = ''
          runHook preInstall

          mkdir -p $out/share/hermes-agent $out/bin
          cp -r ${bundledSkills} $out/share/hermes-agent/skills

          ${pkgs.lib.concatMapStringsSep "\n" (name: ''
            makeWrapper ${hermesVenv}/bin/${name} $out/bin/${name} \
              --suffix PATH : "${runtimePath}" \
              --set HERMES_BUNDLED_SKILLS $out/share/hermes-agent/skills
          '') [ "hermes" "hermes-agent" "hermes-acp" ]}

          runHook postInstall
        '';

        meta = with pkgs.lib; {
          description = "AI agent with advanced tool-calling capabilities";
          homepage = "https://github.com/NousResearch/hermes-agent";
          mainProgram = "hermes";
          license = licenses.mit;
          platforms = platforms.unix;
        };
      }
    else
      flakeInputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default;
  hermesConfig = pkgs.formats.yaml { };
  ollamaBaseUrl = if isMacMini then "http://127.0.0.1:11434/v1" else "http://bryces-mac-mini:11434/v1";
in
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = [ hermesPkg ];

    home.file.".hermes/config.yaml".source = hermesConfig.generate "hermes-config.yaml" {
      model = {
        default = "sinhang/qwen3.5-claude-4.6-opus:27b-q4_K_M";
        provider = "custom";
        base_url = ollamaBaseUrl;
      };
    };

    persistenceDirectories = [ ".hermes" ];
  };
}
