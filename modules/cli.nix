{ pkgs, ... }: {
  home.packages = with pkgs; [
    git-crypt

    # Better alternatives
    ripgrep # grep

    # Structured data
    jq
  ];

  programs.starship = { enable = true; };
}
