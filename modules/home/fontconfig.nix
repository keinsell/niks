{pkgs, ...}: {
  # There is a one cool bitmap font called "eldur" however,
  # i could not find package with it.
  # https://github.com/molarmanful/eldur
  # https://github.com/javierbyte/brutalita
  # ---
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-extra
    fira-code
    fira-code-symbols
    font-awesome
    departure-mono
    (nerdfonts.override {
      fonts = [
        "NerdFontsSymbolsOnly"
        "Hack"
      ];
    })

    # Scientifica seems to be a most detailed
    # and supported one, there are also other
    # options but this feel in category of
    # "it's enough".
    # https://github.com/oppiliappan/scientifica
    scientifica

    # Cozette also seems to be really pretty
    # option without italics of scientifica which
    # are pretty annoying most of the time.
    # Cozette overall is cleaner than scientifica
    cozette

    # Other bintmas that took my atention
    # zpix-pixel-font # too "slim"
    tamzen

    # Siji is a font containtaining glyphs
    # Should not be used directly
    # https://github.com/stark/siji
    # siji

    # Monospace Fonts
    commit-mono
    jetbrains-mono
    monaspace
    _3270font
    _0xproto
    departure-mono

    dejavu_fonts
    powerline-fonts
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        "Departure Mono"
        "cozette"
        "scientifica"
        "0xProto"
        "Commit Mono"
      ];
      # TODO(https://github.com/NixOS/nixpkgs/issues/312826): Migrate into Fluent Emoji
      emoji = ["JoyPixels"];
    };
  };
}
