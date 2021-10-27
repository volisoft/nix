{ config, lib, pkgs, ... }:

with lib;

{
  imports = [ <nixpkgs/nixos/modules/profiles/qemu-guest.nix> ];

  config = {
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "tmpfs";
      autoResize = false;
    };

    boot = {
      growPartition = true;
      kernelParams = [ "console=ttyS0" ];
      loader.grub.device = "/dev/vda";
      loader.timeout = 0;
    };

    users.extraUsers.root.password = "";
  };
}
qemu-system-arm
-machine virt,highmem=off
-bios uboot-qemu_arm_defconfig-2018.03_u-boot.bin
-drive if=none,file=sd-image-armv7l-linux.qcow2,id=mydisk
-device ich9-ahci,id=ahci
-device ide-drive,drive=mydisk,bus=ahci.0
-netdev user,id=net0
-device virtio-net-pci,netdev=net0
-nographic
-smp 4
-m 2G
