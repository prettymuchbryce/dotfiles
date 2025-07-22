{
  description = "Multi-platform Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      claude-code,
      ...
    }:
    {
      # Darwin (macOS) configuration
      darwinConfigurations."Bryces-MacBook-Pro-2" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/darwin
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.bryce.imports = [ ./home.nix ];
            };
          }
        ];
      };

      # NixOS configuration
      nixosConfigurations.meerkat = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.bryce.imports = [ ./home.nix ];
            };
          }
        ];
      };

      # Claude Code
      homeConfigurations."bryce" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux"; # adjust for your system
          overlays = [ claude-code.overlays.default ];
        };
        modules = [
          ./home.nix
        ];
      };

      # Expose package sets for convenience
      darwinPackages = self.darwinConfigurations."Bryces-MacBook-Pro-2".pkgs;
      nixosPackages = self.nixosConfigurations.meerkat.pkgs;
    };
}
