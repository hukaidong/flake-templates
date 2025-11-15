# LaTeX build derivation using latexmk with LuaLaTeX
#
# Parameters:
#   build-target: .tex file(s) to compile (string or list)
#   keep-logs: whether to copy .log files to result/ for debugging
#   extraInputs: additional system packages (e.g., imagemagick, python, R)
#   extraTexlivePackages: additional LaTeX packages beyond texliveFull
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
  name = "latex-pdf";
  src = ./.;

  # Include texliveFull plus any extra packages
  buildInputs = [ (pkgs.texliveFull.withPackages (_: extraTexlivePackages)) ] ++ extraInputs;

  buildPhase = ''
    export HOME=$(mktemp -d)
    mkdir -p .cache/latex

    # Run latexmk with:
    #   -pdf: generate PDF output
    #   -lualatex: use LuaLaTeX engine (better Unicode/font support)
    #   -shell-escape: allow external program execution (for \write18)
    #   -interaction=nonstopmode: don't stop on errors
    #   -f: force compilation even if errors occur
    #   -outdir: put all generated files in cache directory
    latexmk -pdf -lualatex -shell-escape -interaction=nonstopmode -f -outdir=.cache/latex ${lib.strings.concatStringsSep " " targets}
  '';

  installPhase = ''
    mkdir -p $out

    # Copy log files if requested (useful for debugging compilation issues)
    if [ "${builtins.toString keep-logs}" ] ; then
      echo "Keeping log files for debugging..."
      for target in ${lib.strings.concatMapStringsSep " " (x: x) (targets)}; do
        cp .cache/latex/''${target%.tex}.log $out/
      done
    fi

    # Copy the generated PDF files to the result directory
    ${lib.strings.concatMapStringsSep "\n    " (
      target: "cp .cache/latex/${lib.strings.removeSuffix ".tex" target}.pdf $out/"
    ) targets}
  '';
}
