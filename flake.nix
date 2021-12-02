{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, homeManager }@inputs: {
    homeConfigurations = {
      "dev@devmachine" = homeManager.lib.homeManagerConfiguration {
        configuration = import ./home.nix;
        system = "aarch64-linux";
        homeDirectory = "/home/dev";
        username = "dev";
        stateVersion = "20.09";
      };
    };

    nixosConfigurations = {
      # OS: NixOS
      # Dotfiles: home-manager
      # Network: automatically configured
      # Desktop: xfce
      # nix run github:nix-community/nixos-generators -- --flake ".#dev-vm" -f iso
      # cp ../nixos.iso /run/user/1000/gvfs/dav+sd:host=Spice%2520client%2520folder._webdav._tcp.local
      # nix build '.#nixosConfigurations.dev-vm.config.system.build.vm'
      # ./result/bin/run-nixos-vm -cpu max -smp 8 -machine accel=tcg,gic-version=max -vga std -m 800M
      # nix run github:nix-community/nixos-generators -- --flake ".#dev-vm" -f iso
      dev-vm = (import ./systems/vm) inputs;
    };

    # Requires kvm
    # nix build '.#diskImages.dev-vm'
    diskImages = {
      dev-vm = let
      in import "${nixpkgs}/nixos/lib/make-disk-image.nix" {
        format = "qcow";
        config = ((import ./systems/vm) inputs).config;
        diskSize = 2256;
        pkgs = import nixpkgs { system = "aarch64-linux"; };
        lib = nixpkgs.lib;
      };
    };
  };
}
