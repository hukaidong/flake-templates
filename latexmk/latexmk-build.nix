{
  pkgs,
  lib,
  build-target ? "main.tex",
  keep-logs ? false,
  extraInputs ? [ ],
  extraTexlivePackages ? [ ],
  ...
}:
let
  targets = lib.lists.toList build-target;
in
pkgs.stdenv.mkDerivation {
  name = "pdf";
  src = ./.;

  buildInputs = [ (pkgs.texliveFull.withPackages (_: extraTexlivePackages)) ] ++ extraInputs;

  buildPhase = ''
    export HOME=$(mktemp -d)
    mkdir -p .cache/latex
    latexmk -pdf -lualatex -shell-escape -interaction=nonstopmode -outdir=.cache/latex ${lib.strings.concatStringsSep " " targets}
  '';

  installPhase = ''
    mkdir -p $out
    if [ "${builtins.toString keep-logs}" ] ; then
      # copy log files for debugging
      for target in ${lib.strings.concatMapStringsSep " " (x: x) (targets)}; do
        cp .cache/latex/''${target%.tex}.log $out/
      done
    fi
    ${lib.strings.concatMapStringsSep "\n    " (
      target: "cp .cache/latex/${lib.strings.removeSuffix ".tex" target}.pdf $out/"
    ) targets}
  '';
}
