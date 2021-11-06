{ self, nixpkgs, ... }: {
  imports = [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel.nix"
  ];
  sdImage.compressImage = false;
}
