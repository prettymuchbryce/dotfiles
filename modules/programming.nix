{ pkgs, ... }: {
  home.packages = with pkgs; [
    # common
    gnumake

    # C
    gcc

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
    # (python3.withPackages (ps: with ps; [ setuptools pip ]))
    # poetry
    # python3Packages.ipython
    # ruff

    # rust
    # cargo
    # cargo-tarpaulin
    # perl # this is required by rust
    # rustc

    # shell
    shfmt
  ];
}
