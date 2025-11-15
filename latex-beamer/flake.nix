{
  description = "A battery-included LaTeX Beamer template for presentations with Gotham theme and R plotting support";
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

        # R environment with common plotting packages
        rEnv = pkgs.rWrapper.override {
          packages = with pkgs.rPackages; [
            tidyverse
            ggplot2
            dplyr
            gridExtra
          ];
        };

        pdf = pkgs.callPackage ./latexmk-build.nix {
          # Build all .tex files found in the current directory
          build-target = texFiles;
          # Uncomment to build a specific target:
          # build-target = "presentation.tex";

          # Gotham theme requires fira fonts and fira-math
          extraTexLivePackages = with pkgs.texlivePackages; [
            fira
            fira-math
            dejavu-otf
          ];

          # Include R environment for generating plots with \rplotfile macro
          extraInputs = [ rEnv ];

          # Uncomment to save log file to result/ for debugging
          # keep-logs = true;
        };
      in
      rec {
        packages.default = pdf;

        # Development shell with access to all build dependencies
        devShells.default = pkgs.mkShell {
          inputsFrom = [ packages.default ];
          # Add additional development tools here if needed
          # buildInputs = with pkgs; [
          #   texlab  # LaTeX language server
          # ];
        };

        # Check if builds successfully
        checks.build =
          pkgs.runCommand "check-beamer-build"
            {
              buildInputs = [ pkgs.file ];
            }
            ''
              # Build using the default package
              built=${packages.default}

              # Check that at least one PDF was generated
              pdf_count=$(find $built -name "*.pdf" | wc -l)
              if [ "$pdf_count" -eq 0 ]; then
                echo "ERROR: No PDF files were generated!"
                echo "Contents of build output:"
                ls -la $built/
                exit 1
              fi

              echo "SUCCESS: Beamer presentation built successfully!"
              echo "Generated $pdf_count PDF file(s)"

              touch $out
            '';
      }
    );
}
