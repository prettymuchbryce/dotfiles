{ pkgs, pkgs-solana, ... }:
{
  home.packages = with pkgs; [
    pkgs-solana.solana-cli # Use older version from nixos-24.11
    pkgs.evcxr # repl
    (lib.hiPrio rust-analyzer) # Higher priority than rustup's wrapper
    rustup
  ];
}
