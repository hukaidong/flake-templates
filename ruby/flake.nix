{
  # Based on https://github.com/bobvanderlinden/templates/blob/master/ruby/flake.nix
  # Useage: see README.md

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
        ruby = nixpkgs.legacyPackages.${system}.ruby_3_4;
        pkgs = nixpkgs.legacyPackages.${system};
        gems = pkgs.bundlerEnv {
          inherit ruby;
          name = "gemset";
          gemdir = ./.;
          groups = [
            "default"
            "production"
            "development"
            "test"
          ];
        };
      in
      {

        defaultPackage = gems;

        # used by nix shell and nix develop
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            ruby_3_4

            gems
            (lowPrio gems.wrappedRuby)

            bundix
            pkg-config
          ];
        };
      }
    );
}
