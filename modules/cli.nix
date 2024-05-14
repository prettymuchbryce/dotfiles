{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Better alternatives
    ripgrep # grep

    # Structured data
    jq
  ];

  programs.starship = { enable = true; };
}
