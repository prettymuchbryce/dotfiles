{
  pkgs,
  lib,
  flakeRoot,
  ...
}:
{
  home.packages = with pkgs; [ git-crypt ];

  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "Bryce Neal";
          email = "brycedneal@gmail.com";
        };
      };

      # extraConfig = {
      #   pull.ff = "only";
      #   init.defaultBranch = "main";
      #   merge.conflictstyle = "diff3";

      #   # NOTE: Required so that `go get` can fetch private repos
      #   # NOTE: cargo breaks if this is present in the config
      #   # So you have choose between rust or go (Or find a solution for this)
      #   # url."ssh://git@github.com/".insteadOf = "https://github.com/";
      # };
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        features = "side-by-side line-numbers decorations";
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-style = "bold yellow";
          file-decoration-style = "none";
        };
      };
    };

    gh = {
      enable = true;
      settings = "${flakeRoot}/.secrets/gh-config.nix";
    };
  };

  opensnitchRules = [
    {
      name = "Allow gh → api.github.com";
      process = "${lib.getExe pkgs.gh}";
      protocol = "tcp";
      port = 443;
      host = "api.github.com";
    }
  ];
}
