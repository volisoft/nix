{ self, nixpkgs, homeManager, ... }:
(nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem) {
  system = "aarch64-linux";
  modules = [
    ./../base-config.nix
    ./../graphics.nix
    ./boot.nix
    ./fs.nix
    ./qemu-guest.nix
    homeManager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.dev = import ../../home.nix;
    }
    ({ nixpkgs = { config.allowUnfree = true; }; })
  ];
}
