{ lib, stdenv, fetchurl, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "clojure-lsp";
  version = "2021.11.02-15.24.47";
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0ypn0m81lbhx45y0ajpgk7id9g47l1gnihvqdjxw5m1j2hdwjdzr";
  };

  jar = fetchurl {
    url =
      "https://github.com/clojure-lsp/clojure-lsp/releases/download/${version}/clojure-lsp.jar";
    sha256 = "0pd4wsp0c377b5h98w5g0ipvsjdimbyyki13jijcl0hbny4v6jck";
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
