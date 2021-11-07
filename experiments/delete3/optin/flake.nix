{
  description = ''
    Inspired by https://github.com/astralbijection/infra.
    Setups overview: https://nixos.wiki/wiki/Comparison_of_NixOS_setups

    Modified to use flakes from
    https://www.haskellforall.com/2020/11/how-to-use-nixos-for-lightweight.html.
    nix-shell -p nixUnstable --run 'sudo nixos-install --flake github:kanashimia/nixos#literal-potato'
    After changes:
    nix flake lock --recreate-lock-file --refresh
    nix run '.#diskImages.rpi4.config.system.build.vm'
    .../bin/run-nixos-vm -cpu max -smp 8 -machine accel=tcg,gic-version=max -vga std -m 800M
    QEMU options https://wiki.gentoo.org/wiki/QEMU/Options

    Produce image:
    nix build '.#diskImages.rpi4.config.system.build.sdImage'
          '';
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    # "github:nixos/nixpkgs";
  };
  outputs = { self, nixpkgs }@inputs: {
    # In shell:
    # nix run '.#test.vm'
    # error: unable to execute '.../bin/nixos-vm': No such file or directory
    # This path is incorrect. Replace it with:
    # .../bin/run-nixos-vm
    # Could not access KVM kernel module: No such file or directory
    # qemu-system-aarch64: failed to initialize kvm: No such file or directory
    # This happens when KVM kernel module is not loaded (e.g. in a virtual machine).
    # In that case run QEMU in emulation mode:
    # .../bin/run-nixos-vm -cpu max -machine accel=tcg,gic-version=max
    # .../bin/run-nixos-vm -cpu max -smp 8 -machine accel=tcg,gic-version=max
    # If you cannot log in then delete qcow2 file and restart the VM.
    # packages.aarch64-linux = import "${nixpkgs}/nixos" {

    #   system = "aarch64-linux";

    #   configuration = { config, pkgs, ... }: {
    #     # Open the default port for `postgrest` in the firewall
    #     networking.firewall.allowedTCPPorts = [ 3000 ];

    #     # Uncomment the next line for running QEMU on a non-graphical system
    #     # virtualisation.graphics = false;
    #   };
    # };

    # nixosModules = { pi = (import ./rpi4-image.nix) inputs; };
    # see https://github.com/considerate/nixos-odroidhc4/blob/master/nixpkgs/default.nix
    diskImages = {
      rpi4 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          # ./machines/ether/image.nix
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel.nix"
          ./machines/ether/hardware.nix
          ./machines/ether/configuration.nix
        ];
      };
    };
  };
}
