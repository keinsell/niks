{
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      name = "nixos-shell";
      meta.description = "Shell for modyfing NixOS Configuration";
      packages = with pkgs; [
        just
        nixd
      ];
    };
  };
}
