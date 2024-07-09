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

  outputs = { self, nixpkgs, ... } @inputs:
  let
    base = { modules = builtins.toString ./. + "/modules"; };
    hosts = builtins.attrNames inputs.env.hosts;
    user = "he";

    generateHostConfig = host: let
      specialArgs = { inherit inputs base host user; };
      config = {
        inherit specialArgs;
        modules = [
          (./hosts + "/[host]")
          inputs.home-manager.nixosModules.home-manager {
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };
    in config;
  in {
    nixosConfigurations = builtins.listToAttrs (builtins.map (host: {
      name = host;
      value = nixpkgs.lib.nixosSystem (generateHostConfig host);
    }) hosts);
  };
}
