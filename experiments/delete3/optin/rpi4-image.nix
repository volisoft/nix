{ self, nixpkgs, ... }:
let
  image = {
    imports = [
      "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel.nix"
      # ./configuration.nix
    ];

    sdImage.compressImage = false;
  };
in nixpkgs.lib.nixosSystem {

  system = "aarch64-linux";
  modules = [ image ./configuration.nix ./machines/ether/hardware.nix ];
  # boot = {
  #   # The serial ports listed here are:
  #   # - ttyS0: for Tegra (Jetson TX1)
  #   # - ttyAMA0: for QEMU's -machine virt
  #   # - ttyS1: for serial consolse
  #   kernelParams = [
  #     "console=ttyS0,115200n8"
  #     "console=ttyAMA0,115200n8"
  #     "console=tty0"
  #     "console=ttyS1,115200n8"
  #   ];
  # };
  #
  # See https://discourse.nixos.org/t/package-zfs-kernel-2-0-5-5-14-5-is-marked-as-broken-refusing-to-evaluate/15139/5
  # boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackges;
}
