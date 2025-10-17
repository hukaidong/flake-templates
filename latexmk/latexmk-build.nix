{
  pkgs,
  lib,
  build-target ? "main.tex",
  ...
}:
let
  targets = lib.lists.toList build-target;
in
pkgs.stdenv.mkDerivation {
  name = "pdf";
  src = ./.;

  buildInputs = [ pkgs.texliveFull ];

  buildPhase = ''
    export HOME=$(mktemp -d)
    mkdir -p .cache/latex
    latexmk -pdf -lualatex -shell-escape -interaction=nonstopmode -outdir=.cache/latex ${lib.strings.concatStringsSep " " targets}
  '';

  installPhase = ''
    mkdir -p $out
    ${lib.strings.concatMapStringsSep "\n    " (target: "cp .cache/latex/${lib.strings.removeSuffix ".tex" target}.pdf $out/") targets}
  '';
}
