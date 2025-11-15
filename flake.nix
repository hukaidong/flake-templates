{
  description = "A collection of flake templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    {
      templates = {
        latexmk = {
          path = ./latexmk;
          description = "A simple LaTeX template for writing documents with latexmk";
        };

        latex-beamer = {
          path = ./latex-beamer;
          description = "A battery-included LaTeX Beamer template for presentations with Gotham theme and R plotting support";
        };

        ruby = {
          path = ./ruby;
          description = "A simple Ruby template";
        };

        R = {
          path = ./r;
          description = "A simple R template";
        };

        empty = {
          path = ./empty;
          description = "An empty template";
        };
      };
    }
    // import ./tests { inherit self nixpkgs flake-utils; };
}
