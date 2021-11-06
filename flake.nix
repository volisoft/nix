{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, homeManager }: {
    homeConfigurations = {
      "dev@devmachine" = homeManager.lib.homeManagerConfiguration {
        configuration = import ./home.nix;
        system = "aarch64-linux";
        homeDirectory = "/home/dev";
        username = "dev";
        stateVersion = "20.09";
      };
    };

  };
}
