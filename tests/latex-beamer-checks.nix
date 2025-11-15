{ nixpkgs, flake-utils, ... }:
let
  # Evaluate the latex-beamer template flake
  latexBeamerFlake = (import ../latex-beamer/flake.nix).outputs {
    self = {
      outPath = ../latex-beamer;
    };
    inherit nixpkgs flake-utils;
  };
in
flake-utils.lib.eachDefaultSystem (
  system: {
    checks.latex-beamer-template = latexBeamerFlake.checks.${system}.build;
  }
)
