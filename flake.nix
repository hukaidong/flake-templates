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

        # TODO: implement full-featured Beamer template
        latex-beamer = {
          #path = ./latex-beamer;
          path = ./latexmk; # temporary placeholder
          description = "A battery-included LaTeX Beamer template for presentations";
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
