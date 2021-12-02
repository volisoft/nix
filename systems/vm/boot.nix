{ pkgs, ... }: {
  # Causes infinite recursion
  # imports = [ "${pkgs}/nixos/modules/installer/scan/not-detected.nix" ];

  boot = {
    loader = {
      grub.copyKernels = true;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
  };
}
