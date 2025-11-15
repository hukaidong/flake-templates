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
      rec {
        packages.default = pkgs.callPackage ./latexmk-build.nix {
          # build all .tex files found in the current directory
          build-target = texFiles;
          # uncomment if you want to build a specific target (or multiple targets)
          # build-target = "main.tex";
          # build-target = [ "main.tex" "main-2.tex" ];

          # uncomment to pass additional latex packages (font packages, etc.)
          # extraTexLivePackages = with pkgs.texlivePackages; [
          #   fira-math  # modern math font
          #   fira       # modern text font
          #   libertine   # serif font alternative
          # ];

          # uncomment to pass additional system packages (e.g., imagemagick, python, R)
          # extraInputs = with pkgs; [
          #   imagemagick  # image processing
          #   python3      # for Python scripts
          #   rWrapper     # for R scripts
          # ];

          # uncomment if you want to save log file to result/ for debugging
          # keep-logs = true;
        };

        # Development shell with access to all build dependencies
        devShells.default = pkgs.mkShell {
          inputsFrom = [ packages.default ];
          # Add additional development tools here
          # buildInputs = with pkgs; [
          #   texlab  # LaTeX language server
          #   vscode  # or your preferred editor
          # ];
        };

        # Check if builds successfully
        checks.build =
          pkgs.runCommand "check-latexmk-build"
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

              echo "SUCCESS: All PDFs built and validated successfully!"
              echo "Generated $pdf_count PDF file(s)"

              touch $out
            '';
      }
    );
}
