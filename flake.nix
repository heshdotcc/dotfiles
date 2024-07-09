{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ownpkgs.url = "github:heshdotcc/ownpkgs";
    env.url = "git+file:///home/he/crypt"; 
  };

  outputs = { self, ... } @inputs:
  let
    user = "he";
    base = {
      modules = builtins.toString ./. + "/modules";
    };
    specialArgs = { inherit inputs user base; };
  in {
    nixpkgs.overlays = [ inputs.ownpkgs.nvim.overlays.default ];
    nixosModules = import ./modules/nixos;
    homeModules = import ./modules/home; 
    nixosConfigurations = { 
      melchior = inputs.nixpkgs.lib.nixosSystem {
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
