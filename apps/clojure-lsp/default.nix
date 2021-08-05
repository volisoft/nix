{ lib, stdenv, fetchurl, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "clojure-lsp";
  version = "2021.08.03-13.33.03";
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1la0d28pvp1fqnxp3scb2vawcblilwyx42djxn379vag403p1i2d";
  };

  jar = fetchurl {
    url =
      "https://github.com/clojure-lsp/clojure-lsp/releases/download/${version}/clojure-lsp.jar";
    sha256 = "0wwm2cd45zbnvr1p6lw60xdfal4jz91n9g5npvi00mav7qyzchhb";
  };

  buildInputs = [ ];

  buildPhase = with lib; ''
    runHook preBuild

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 $jar $out/bin/clojure-lsp

    runHook postInstall
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    runHook postCheck
  '';

  meta = with lib; {
    description = "Language Server Protocol (LSP) for Clojure";
    homepage = "https://github.com/clojure-lsp/clojure-lsp";
    license = licenses.mit;
    maintainers = [ "oliinyk" ];
    platforms = [ "aarch64-linux" ];
  };
}
