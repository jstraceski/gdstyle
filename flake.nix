{
  description = "gdstyle: a fast, opinionated linter and formatter for GDScript (Godot 4.x)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    crane.url = "github:ipetkov/crane";
  };

  outputs =
    { self, nixpkgs, crane }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      craneLib = crane.mkLib pkgs;

      gdstyle = craneLib.buildPackage rec {
        pname = "gdstyle";
        version = "0.6.9";
        src = ./.;
        cargoExtraArgs = "-p gdstyle";
        doCheck = false;
      };
    in
    {
      packages.${system} = {
        default = gdstyle;
        inherit gdstyle;
      };

      devShells.${system}.default = pkgs.mkShell {
        name = "gdstyle-dev-shell";
        packages = [
          pkgs.cargo
          gdstyle
        ];
      };
    };
}
