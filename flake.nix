{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs";
  };
  outputs = { self, utils, nixpkgs }:
  (utils.lib.eachSystem [ "x86_64-linux" ] (system:
  let
    pkgsLut = {
      x86_64-linux = nixpkgs.legacyPackages.${system}.extend self.overlay;
    };
    pkgs = pkgsLut.${system};
  in {
    packages = {
      inherit (pkgs) openhmd;
    };
    hydraJobs = {
      inherit (self) packages;
    };
    devShell = pkgs.openhmd;
  })) // {
    overlay = self: super: {
      openhmd = self.callPackage ./openhmd.nix {};
    };
  };
}
