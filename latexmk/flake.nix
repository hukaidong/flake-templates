{
  description = "A simple LaTeX template for writing documents with latexmk";
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
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;
        readDirToOnlyFiles =
          readDirResult:
          lib.mapAttrsToList (k: _: k) (lib.filterAttrs (_: type: type == "regular") readDirResult);
        texFiles = (
          builtins.filter (file: lib.hasSuffix ".tex" file) (readDirToOnlyFiles (builtins.readDir ./.))
        );

      in
      {
        packages.default = pkgs.callPackage ./latexmk-build.nix {
          # build all .tex files found in the current directory
          build-target = texFiles;
          # uncomment if you want to build a specific target (or multiple targets)
          # build-target = "main.tex";
          # build-target = [ "main.tex" "main-2.tex" ];

          # uncomment to pass additional latex packages (font packages, etc.)
          # extraTexLivePackages = with pkgs.texlivePackages; [ fira-math ];

          # uncomment to pass additional system packages (e.g., imagemagick)
          # extraInputs = with pkgs; [ imagemagick ];

          # uncomment if you want to save log file to result/
          # keep-logs = true;
        };
      }
    );
}
