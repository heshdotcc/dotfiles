{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nvim.url = "github:heshdotcc/nvim-flake";
    env.url = "git+file:///home/he/.crypt"; 
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    user = "he";
    base = {
      modules = builtins.toString ./. + "/modules";
    };
    specialArgs = { inherit inputs user base; };
  in
  {
    nixpkgs.overlays = [ inputs.nvim.overlay.default ];
    nixosModules = import ./modules/nixos;
    homeModules = import ./modules/home; 
    nixosConfigurations = { 
      melchior = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/melchior/soft.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
            };
          }
        ];
      };
    };
  };
}
