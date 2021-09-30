{ lib, stdenv, fetchurl, fetchFromGitHub }:
# TODO needs npm build for aarch64, because there's no downloadable build
stdenv.mkDerivation rec {
  owner = "wilkerlucio";
  pname = "pathom-viz";
  version = "2021.7.16";
  src = fetchFromGitHub {
    owner = owner;
    repo = pname;
    rev = version;
    sha256 = "e6d7804d015f8fb8e88cbec59965fca0dd685803";
  };

  jar = fetchurl {
    url =
      "https://github.com/wilkerlucio/pathom-viz/releases/download/v${version}/pathom-viz_${version}_amd64.deb";
    sha256 = "17y6wrybavy1kijdfd0dpb3kbkrj1l7vj9kdb896ai0b468d29qr";
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
