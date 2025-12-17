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
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    try.url = "github:tobi/try";
    mistral-vibe.url = "github:mistralai/mistral-vibe";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nixpkgs-solana,
      home-manager,
      claude-code,
      nix-flatpak,
      lanzaboote,
      impermanence,
      try,
      mistral-vibe,
      ...
    }:
    {
      # Darwin (macOS) configuration
      darwinConfigurations."Bryces-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/darwin
          home-manager.darwinModules.home-manager
          {
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
                  _module.args.pkgs-solana = import nixpkgs-solana {
                    system = "aarch64-darwin";
                    config.allowUnfree = true;
                  };
                  _module.args.mistral-vibe = mistral-vibe.packages.aarch64-darwin.default;
                }
              ];
            };
          }
        ];
      };

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
