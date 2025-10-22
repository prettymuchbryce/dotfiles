{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    fnm
  ];

  # In a fresh environment always install node LTS on activation
  home.activation.ensureFnmLts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    set -euo pipefail

    # Sets the FNM_DIR environment variable
    eval "$(${pkgs.fnm}/bin/fnm env --shell bash)"

    # Path to the directory wherein fnm stores node versions
    versions_dir="''${FNM_DIR}/node-versions"

    # If the directory for versions does not exist, or is empty then install lts
    if [[ ! -d "$versions_dir" ]] || [[ -z $(ls "$versions_dir") ]]; then
      ${pkgs.fnm}/bin/fnm install --lts
    fi
  '';

  programs.zsh.initContent = ''
    eval "$(fnm env --use-on-cd)"
  '';
}
