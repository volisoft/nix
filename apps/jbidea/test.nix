with import <nixpkgs> {};
let
  jetbrains = pkgs.callPackage ./default.nix {};
in
  jetbrains.idea-community

