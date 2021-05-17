{ config, lib, pkgs, ... }:

{
  nixpkgs.localSystem.system = "aarch64-linux";
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel.nix>
    ./configuration.nix
  ];

  boot = {
    # The serial ports listed here are:
    # - ttyS0: for Tegra (Jetson TX1)
    # - ttyAMA0: for QEMU's -machine virt
    # - ttyS1: for serial consolse
    kernelParams = [
      "console=ttyS0,115200n8"
      "console=ttyAMA0,115200n8"
      "console=tty0"
      "console=ttyS1,115200n8"
    ];
  };
}
