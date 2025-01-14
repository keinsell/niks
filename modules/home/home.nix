{
  pkgs,
  config,
  ...
}: {
  # Nix packages to install to $HOME
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs;
    [
      # Base
      coreutils-full
      findutils
      tree
      unzip
      wget
      zstd

      # Build and compilation tools
      sccache
      ripgrep
      fd
      sd
      tree
      gnumake
      just

      # Nix dev
      devenv
      cachix
      nixd
      nil
      statix
      deadnix
      alejandra
      nh
      nix-info
      nixpkgs-fmt
      comma

      # Knowledge-base Management
      markdown-oxide
      marksman
      glow

      # On ubuntu, we need this less for `man home-configuration.nix`'s pager to
      # work.
      less
      rustup
      bun
      deno

      # Security
      keybase
      age
      age-plugin-ledger
      age-plugin-fido2-hmac

      lazyjj
    ]
    ++ (with nodePackages; [pnpm])
    ++ (
      if pkgs.stdenv.isDarwin
      then (with pkgs.darwin.apple_sdk.frameworks; [CoreServices Foundation Security])
      else []
    );

  home.file = {
    "${config.xdg.configHome}/ghostty/config".source = ../../dotfiles/ghostly.toml;
    ".cargo/config.toml".source = ../../dotfiles/cargo.toml;
  };


  programs = {
    bat.enable = true;
    # Type `<ctrl> + r` to fuzzy search your shell history
    fzf.enable = true;
    jq.enable = true;
    jujutsu.enable = true;
    home-manager.enable = true;
    browserpass.enable = true;
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
  };
}
