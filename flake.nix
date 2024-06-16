{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix.url = "github:yaxitech/ragenix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    user = "he";
    specialArgs = { inherit inputs user; };
  in {
    nixosModules = import ./modules/nixos;
    homeModules = import ./modules/home; 
    nixosConfigurations = { 
      melchior = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/melchior/soft.nix
          inputs.home-manager.nixosModules.home-manager {
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };
    };
  };
}
