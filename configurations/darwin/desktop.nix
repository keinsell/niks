# See /modules/darwin/* for actual settings
# This file is just *top-level* configuration.
{
  flake,
  pkgs,
  lib,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.darwinModules.default
  ];

  # Configure nixpkgs to use experimental features and allow
  # to use non-free software.
  nixpkgs = {
    # aarch64-darwin is necessary when using Apple Silicon
    hostPlatform = "aarch64-darwin";
    config = {
      allowUnfree = true;
      allowBroken = false;
    };
  };

  networking.hostName = "desktop";

  users.users = {
    "jakub" = {};
    "keinsell" = {
      home = "/Users/keinsell";
      shell = lib.getExe pkgs.nushell;
    };
    "admin" = {};
  };

  # Enable home-manager for "runner" user
  home-manager = {
    users."keinsell" = {
      imports = [(self + /configurations/home/keinsell.nix)];
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
