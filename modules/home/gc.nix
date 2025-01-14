{
  # Garbage collect the Nix store
  nix.gc.frequency = "hourly";
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 15d";
}
