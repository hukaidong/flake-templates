{ nixpkgs, flake-utils, ... }:
let
  # Evaluate the latexmk template flake
  latexmkFlake = (import ../latexmk/flake.nix).outputs {
    self = {
      outPath = ../latexmk;
    };
    inherit nixpkgs flake-utils;
  };
in
flake-utils.lib.eachDefaultSystem (
  system: {
    checks.latexmk-template = latexmkFlake.checks.${system}.build;
  }
)
