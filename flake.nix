{
  description = "Revolt Desktop";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];

      perSystem = {
        system,
        pkgs,
        ...
      }: {
        packages.default = pkgs.callPackage ./pkgs/revolt-desktop.nix {
          inherit (pkgs) lib stdenv fetchFromGitHub yarn electron makeWrapper;
        };
      };
    };
}
