{
  description = "A flake for yt-local service";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs, ... }:
    let
      pkgs = import nixpkgs {};
      yt-local = import ./yt-local-service.nix;
    in
    {
      packages.x86_64-linux.default = yt-local;
    };
}
