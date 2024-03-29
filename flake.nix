{
  description = "A flake for building yawp.dev with zola";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          yawp = pkgs.stdenv.mkDerivation {
            pname = "yawp";
            version = if self ? rev then self.rev else "dirty";
            src = ./.;
            nativeBuildInputs = [ pkgs.zola ];
            buildPhase = "zola build";
            installPhase = "cp -r public $out";
          };
          default = yawp;
          devShell = pkgs.mkShell { packages = with pkgs; [ zola ]; };
        };
      });
}
