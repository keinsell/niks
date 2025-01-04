# This is your nix-darwin configuration.
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
  # Nix configuration -------------------------------------------------------------
  # https://github.com/malob/nixpkgs/blob/8a5e614fe022476f7629a9c9f41c9e32d83ff625/darwin/bootstrap.nix#L9C1-L40C1

  nix.settings = {
    trusted-users = ["root" "keinsell" "@admin"];

    # https://github.com/NixOS/nix/issues/7273
    auto-optimise-store = false;

    experimental-features = [
      "nix-command"
      "flakes"
    ];

    extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    # Recommended when using `direnv` etc.
    keep-derivations = true;
    keep-outputs = true;
  };

  nix.configureBuildUsers = true;
  services.nix-daemon.enable = true;

  # Use TouchID for `sudo` authentication
  security.pam.enableSudoTouchIdAuth = true;

  # Configure macOS system
  # More examples => https://github.com/ryan4yin/nix-darwin-kickstarter/blob/main/rich-demo/modules/system.nix
  system = {
    defaults = {
      dock = {
        # autohide = true;
        # customize Hot Corners
        wvous-tl-corner = 2; # top-left - Mission Control
        # wvous-tr-corner = 13; # top-right - Lock Screen
        wvous-bl-corner = 3; # bottom-left - Application Windows
        wvous-br-corner = 4; # bottom-right - Desktop
      };

      finder = {
        _FXShowPosixPathInTitle = true; # show full path in finder title
        AppleShowAllExtensions = true; # show all file extensions
        FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
        QuitMenuItem = true; # enable quit menu item
        ShowPathbar = true; # show path bar
        ShowStatusBar = true; # show status bar
      };
    };

    keyboard = {
      enableKeyMapping = true;
      # remapCapsLockToControl = true;
    };
  };

  # Shells -------------------------------------------------------------------

  # Configuration of shell is a matter of home management rather than system
  # configuration itself, so it's omited there and one should be contained in
  # home-manager module.

  environment.shells = [pkgs.zsh pkgs.nushell];

  environment.systemPackages = [
    pkgs.nh
  ];

  homebrew = {
    enable = true;
    global.brewfile = true;

    casks = [
      "discord"
      "httpie"
      "jetbrains-toolbox"
      "obsidian"
      "raycast"
      "stats"
      "utm"
      "zed@preview"
      "1password@nightly"
      "wakatime" # System-wide timetracking
      "wail" # Web Archiving integration layer
      "codeedit" # MacOS-native code editor
      "amethyst" # Tiling window manager
      "jetbrains-toolbox" # JetBrains Toolbox
      "jetbrains-gateway" # Remote development gateway by Jetbrains
      "fleet" # Hybrid IDE by Jetbrains
      "typefully" # Twitter client
      "abstract"
      "sketch@beta"
      "onyx" # Verify system files structure, run miscellaneous maintenance and more
      "keybase" # Open-source key server, git and file storage
    ];

    brews = [
      "liquibase"
    ];

    taps = [
      "earthly/earthly"
      "homebrew/bundle"
      "homebrew/services"
    ];

    # Applications to be installed from Apple App Store
    masApps = {
      "1Password for Safari" = 1569813296;
      # "1Password 7" = 1333542190;
      Xcode = 497799835;
      TestFlight = 899247664;
    };

    whalebrews = [];
  };

  services = {
    # Podjebane z https://raw.githubusercontent.com/jasonmc/nix-darwin-config/refs/heads/master/roles/yabai.nix
    # https://cmacr.ae/blog/yabai-module-in-nix-darwin-now-generally-available/
    # https://mynixos.com/nix-darwin/option/services.yabai.config
    #
    yabai = {
      enable = false;
      package = pkgs.yabai;
      enableScriptingAddition = true;
      config = {
        focus_follows_mouse = "autoraise";
        mouse_follows_focus = "off";
        window_placement = "second_child";
        window_opacity = "off";
        window_opacity_duration = "0.0";
        window_border = "on";
        window_border_placement = "inset";
        window_border_width = 2;
        window_border_radius = 3;
        active_window_border_topmost = "off";
        window_topmost = "on";
        window_shadow = "float";
        active_window_border_color = "0xff5c7e81";
        normal_window_border_color = "0xff505050";
        insert_window_border_color = "0xffd75f5f";
        active_window_opacity = "1.0";
        normal_window_opacity = "1.0";
        split_ratio = "0.50";
        auto_balance = "on";
        mouse_modifier = "fn";
        mouse_action1 = "move";
        mouse_action2 = "resize";
        layout = "bsp";
        top_padding = 36;
        bottom_padding = 10;
        left_padding = 10;
        right_padding = 10;
        window_gap = 10;
      };
    };

    skhd = {
      enable = false;
      package = pkgs.skhd;
    };
  };
}
