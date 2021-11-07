{ lib, pkgs, modulesPath, ... }: {
  imports =
    [ "${modulesPath}/installer/sd-card/sd-image-aarch64-new-kernel.nix" ];
  # TODO https://github.com/considerate/nixos-odroidhc4/blob/f387a51ebe32a7bbca5ee831e9d235a4603aacd4/modules/sd-image/default.nix#L38
  sdImage.compressImage = false;

}
