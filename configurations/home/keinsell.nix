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
    self.homeModules.default
  ];
  home.username = "keinsell";
  home.homeDirectory = lib.mkDefault "/${
    if pkgs.stdenv.isDarwin
    then "Users"
    else "home"
  }/keinsell";
  home.stateVersion = "24.11";
}
