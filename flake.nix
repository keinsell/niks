{
  description = "@keinsell's Home Configuration";

  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-unified.url = "github:srid/nixos-unified";
    spicetify.url = "github:gerg-l/spicetify-nix";
    sops.url = "github:mic92/sops-nix";
    nur.url = "github:nix-community/nur";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    fh = {
      url = "https://flakehub.com/f/DeterminateSystems/fh/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty.url = "github:ghostty-org/ghostty";
    jelly = {
      url = "github:lucperkins/jelly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "https://flakehub.com/f/nix-community/fenix/0.1.*";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-checker = {
      url = "https://flakehub.com/f/DeterminateSystems/flake-checker/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nuenv = {
      url = "https://flakehub.com/f/DeterminateSystems/nuenv/0.1.*";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
    stylix.url = "github:danth/stylix";
  };

  # Wired using https://nixos-unified.org/autowiring.html
  outputs = inputs
  : let
    inherit inputs;
    caches.nixos-org = {
      cache = "https://cache.nixos.org";
      publicKey = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
    };
    caches.nix-community = {
      cache = "https://nix-community.cachix.org";
      publicKey = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    };
  in
    inputs.nixos-unified.lib.mkFlake
    {
      inherit inputs;
      root = ./.;
    };
}
