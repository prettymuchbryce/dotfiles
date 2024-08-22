{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # common
    gnumake
    libiconv

    # Solana
    solana-cli

    # C
    # gcc

    # docker
    # docker
    # docker-compose

    # node
    fnm # Fast node version manager

    # go
    # go
    # golangci-lint

    # JavaScript
    # nodejs
    # yarn
    # nodePackages.prettier

    # lua
    lua

    # python
    (python3.withPackages (
      ps: with ps; [
        setuptools
        pip
        openai
        simple-http-server
        pipx
      ]
    ))
    poetry

    # python3Packages.ipython
    # ruff

    postgresql

    # rust
    rustup

    # shell
    shfmt

    # nix
    nixfmt-rfc-style

    # yaml
    yamlfix
  ];
}
