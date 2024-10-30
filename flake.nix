{
  description = "MIT 6.S081 Environment";
  inputs = {
    nixpkgs.url = "pkgs";

    systems.url = "github:nix-systems/x86_64-linux";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      formatter = pkgs.alejandra;

      devShells.default = pkgs.mkShellNoCC {
        name = "MIT 6.S081 DEV";

        packages = [
          pkgs.gdb
        ];

        buildInputs = [
          pkgs.bear
          pkgs.qemu
          pkgs.gcc12
          pkgs.pkgsCross.riscv64.buildPackages.gcc
        ];

        shellHook = ''
          export CLASS_HOME=`pwd`
          export PATH="$CLASS_HOME/bin:$PATH"
        '';
      };
    });
}
