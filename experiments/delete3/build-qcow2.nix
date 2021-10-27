{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ./machine-config.nix
  ];

  system.build.qcow2 = import <nixpkgs/nixos/lib/make-disk-image.nix> {
    inherit lib config;
    pkgs = import <nixpkgs> { inherit (pkgs) system; };
    diskSize = 2000;
    format = "qcow2";
    configFile = pkgs.writeText "configuration.nix" ''
      {
        imports = [<./machine-config.nix>];
      }
    '';
  };
}
