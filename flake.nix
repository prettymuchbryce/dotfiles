{
  description = "Multi-platform Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # Older nixpkgs for packages with build issues on latest
    nixpkgs-solana.url = "github:NixOS/nixpkgs/nixos-24.11";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    claude-code.url = "github:sadjow/claude-code-nix";
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    try.url = "github:tobi/try";
    autotidy.url = "github:prettymuchbryce/autotidy";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nixpkgs-solana,
      home-manager,
      claude-code,
      codex-cli-nix,
      nix-flatpak,
      lanzaboote,
      impermanence,
      try,
      autotidy,
      ...
    }:
    let
      # Helper function to create darwin configurations
      mkDarwinConfiguration =
        hostname:
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./hosts/darwin
            home-manager.darwinModules.home-manager
            {
              nixpkgs.overlays = [
                claude-code.overlays.default
                # Override fish to skip tests (they fail on macOS)
                (final: prev: {
                  fish = prev.fish.overrideAttrs (oldAttrs: {
                    doCheck = false;
                  });
                })
              ];
              _module.args.flakeRoot = self;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.bryce.imports = [
                  ./home.nix
                  try.homeModules.default
                  autotidy.homeModules.default
                  {
                    _module.args.flakeInputs = inputs;
                    _module.args.flakeRoot = self;
                    _module.args.hostname = hostname;
                    _module.args.pkgs-solana = import nixpkgs-solana {
                      system = "aarch64-darwin";
                      config.allowUnfree = true;
                    };
                  }
                ];
              };
            }
          ];
        };
    in
    {
      # Darwin (macOS) configurations
      darwinConfigurations."Bryces-MacBook-Pro" = mkDarwinConfiguration "Bryces-MacBook-Pro";
      darwinConfigurations."Bryces-Mac-mini" = mkDarwinConfiguration "Bryces-Mac-mini";

      # NixOS configuration
      nixosConfigurations.meerkat = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos
          nix-flatpak.nixosModules.nix-flatpak
          lanzaboote.nixosModules.lanzaboote
          impermanence.nixosModules.impermanence
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [ claude-code.overlays.default ];
            _module.args.flakeRoot = self;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.bryce.imports = [
                ./home.nix
                try.homeModules.default
                {
                  _module.args.flakeInputs = inputs;
                  _module.args.flakeRoot = self;
                  _module.args.hostname = "meerkat";
                }
              ];
            };
          }
        ];
      };

      # Expose package sets for convenience
      darwinPackages = self.darwinConfigurations."Bryces-MacBook-Pro".pkgs;
      nixosPackages = self.nixosConfigurations.meerkat.pkgs;
    };
}
