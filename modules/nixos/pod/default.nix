# This is your nixos configuration.
# For home configuration, see /modules/home/*
{
  flake,
  pkgs,
  lib,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  nix.settings.trusted-users = ["root" "keinsell"];
  services.openssh.enable = true;
}
