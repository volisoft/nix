{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/installer/scan/not-detected.nix" ];

  boot.initrd.availableKernelModules = [
    "ata_generic"
    "uhci_hcd"
    "ehci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelPackages =
    lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = lib.mkForce [ "zfs" ];

  fileSystems."/" = lib.mkForce {
    device = "rpool/root/nixos";
    fsType = "zfs";
    options = [ "noatime" ];
  };

  fileSystems."/nix" = {
    device = "rpool/nix";
    fsType = "zfs";
    neededForBoot = true;
    options = [ "noatime" ];
  };

  fileSystems."/home" = {
    device = "rpool/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    # device = "/dev/disk/by-uuid/8d11e1ec-50db-4aa3-a920-788e7f88b68e";
    device = "/dev/disk/by-uuid/FIRMWARE";
    fsType = "ext4";
  };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 2;
  # High-DPI console
  # console.font =
  #   lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
}
