{ lib, stdenv, callPackage, fetchurl
, jdk, cmake, zlib, python3
, autoPatchelfHook
, libdbusmenu
, vmopts ? null
}:

with lib;

let
  mkJetBrainsProduct = callPackage ./common.nix { inherit vmopts; };

  buildIdea = { name, version, src, license, description, wmClass, ... }:
    (mkJetBrainsProduct {
      inherit name version src wmClass jdk;
      product = "IDEA";
      extraLdPath = [ zlib ];
      meta = with lib; {
        homepage = "https://www.jetbrains.com/idea/";
        inherit description license;
        longDescription = ''
          IDE for Java SE, Groovy & Scala development Powerful
          environment for building Google Android apps Integration
          with JUnit, TestNG, popular SCMs, Ant & Maven. Also known
          as IntelliJ.
        '';
        maintainers = with maintainers; [ edwtjo gytis-ivaskevicius ];
        platforms = [ "aarch64-linux" "x86_64-darwin" "i686-darwin" "i686-linux" "x86_64-linux" ];
      };
    });

in
{
  idea-community = buildIdea rec {
    name = "idea-community-${version}";
    version = "2021.1"; /* updated by script */
    description = "Integrated Development Environment (IDE) by Jetbrains, community edition";
    license = lib.licenses.asl20;
    src = fetchurl {
      url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
      sha256 = "1d7m39rzdgh2fyx50rpifqfsdmvfpi04hjp52pl76m35gyb5hsvs"; /* updated by script */
    };
    wmClass = "jetbrains-idea-ce";
    update-channel = "IntelliJ IDEA RELEASE";
  };

}
