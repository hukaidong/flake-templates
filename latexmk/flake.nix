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
          build-target = texFiles;
        };
      }
    );
}
